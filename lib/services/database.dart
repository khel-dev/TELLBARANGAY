import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  // ============ USER OPERATIONS ============
  /// Check if username already exists
  Future<bool> checkUsernameExists(String username) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // If error occurs, assume username doesn't exist to allow registration
      print('Error checking username: $e');
      return false;
    }
  }

  /// maghimo syag user profile sa Firestore otomatik!!!
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String role,
    String? position,
    String? username,
    String? address,
    String? contact,
    String? barangay,
    String? age,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'username': username ?? '',
        'role': role,
        'position': position ?? '',
        'address': address ?? '',
        'contact': contact ?? '',
        'barangay': barangay ?? '',
        'age': age ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error creating user profile: $e');
    }
  }

  /// Get user profile by UID
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  /// Get all users (for admin/analytics)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final snapshot = await _db.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // ============ REPORT OPERATIONS ============
  /// Create a new report
  Future<String> createReport({
    required String title,
    required String description,
    required String category,
    required List<String> photoUrls,
    required String createdBy,
  }) async {
    try {
      final docRef = _db.collection('reports').doc();
      await docRef.set({
        'reportId': docRef.id,
        'title': title,
        'description': description,
        'category': category,
        'photos': photoUrls,
        'status': 'Pending',
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating report: $e');
    }
  }

  /// Get all reports (real-time stream)
  Stream<List<Map<String, dynamic>>> getReportsStream() {
    try {
      return _db
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }

  /// Get reports for a specific user
  Stream<List<Map<String, dynamic>>> getUserReportsStream(String uid) {
    // Try with orderBy first, fallback to manual sorting if index doesn't exist
    return _db
        .collection('reports')
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final reports = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      
      // Sort manually by createdAt (descending)
      reports.sort((a, b) {
        final aTime = a['createdAt'];
        final bTime = b['createdAt'];
        if (aTime == null || bTime == null) return 0;
        
        // Handle Firestore Timestamp
        if (aTime is Map && bTime is Map) {
          final aSec = aTime['_seconds'] as int? ?? 0;
          final bSec = bTime['_seconds'] as int? ?? 0;
          return bSec.compareTo(aSec); // Descending
        }
        
        // Handle DateTime
        if (aTime is DateTime && bTime is DateTime) {
          return bTime.compareTo(aTime);
        }
        
        return 0;
      });
      
      return reports;
    });
  }

  /// Get a single report
  Future<Map<String, dynamic>?> getReport(String reportId) async {
    try {
      final doc = await _db.collection('reports').doc(reportId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching report: $e');
    }
  }

  /// Update report status
  Future<void> updateReportStatus(String reportId, String newStatus) async {
    try {
      await _db.collection('reports').doc(reportId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for the report owner
      final report = await getReport(reportId);
      if (report != null) {
        String message = '';
        if (newStatus == 'In Progress') {
          message = 'Your report "${report['title'] ?? 'Report'}" is now being processed by the barangay office.';
        } else if (newStatus == 'Solved') {
          message = 'Great news! Your report "${report['title'] ?? 'Report'}" has been resolved.';
        }
        if (message.isNotEmpty) {
          await createNotification(
            toUid: report['createdBy'],
            message: message,
            type: 'report_update',
          );
        }
      }
    } catch (e) {
      throw Exception('Error updating report status: $e');
    }
  }

  /// Delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      await _db.collection('reports').doc(reportId).delete();
    } catch (e) {
      throw Exception('Error deleting report: $e');
    }
  }

  // ============ REQUEST OPERATIONS ============
  /// Create a new request
  Future<String> createRequest({
    required String type,
    required String purpose,
    required String fullName,
    required String proofUrl,
    required String createdBy,
  }) async {
    try {
      final docRef = _db.collection('requests').doc();
      await docRef.set({
        'requestId': docRef.id,
        'type': type,
        'purpose': purpose,
        'fullName': fullName,
        'proofUrl': proofUrl,
        'status': 'Pending',
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating request: $e');
    }
  }

  /// Get all requests (real-time stream)
  Stream<List<Map<String, dynamic>>> getRequestsStream() {
    try {
      return _db
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      throw Exception('Error fetching requests: $e');
    }
  }

  /// Get requests for a specific user
  Stream<List<Map<String, dynamic>>> getUserRequestsStream(String uid) {
    // Try with orderBy first, fallback to manual sorting if index doesn't exist
    return _db
        .collection('requests')
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      
      // Sort manually by createdAt (descending)
      requests.sort((a, b) {
        final aTime = a['createdAt'];
        final bTime = b['createdAt'];
        if (aTime == null || bTime == null) return 0;
        
        // Handle Firestore Timestamp
        if (aTime is Map && bTime is Map) {
          final aSec = aTime['_seconds'] as int? ?? 0;
          final bSec = bTime['_seconds'] as int? ?? 0;
          return bSec.compareTo(aSec); // Descending
        }
        
        // Handle DateTime
        if (aTime is DateTime && bTime is DateTime) {
          return bTime.compareTo(aTime);
        }
        
        return 0;
      });
      
      return requests;
    });
  }

  /// Get a single request
  Future<Map<String, dynamic>?> getRequest(String requestId) async {
    try {
      final doc = await _db.collection('requests').doc(requestId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching request: $e');
    }
  }

  /// Update request status (for officials)
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      await _db.collection('requests').doc(requestId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for the request owner
      final request = await getRequest(requestId);
      if (request != null) {
        String message = '';
        if (newStatus == 'Approved') {
          message = 'Your request has been approved! You can now claim at the barangay hall.';
        } else if (newStatus == 'Rejected') {
          message = 'Your request was not approved. Please visit the barangay hall for more information.';
        }
        if (message.isNotEmpty) {
          await createNotification(
            toUid: request['createdBy'],
            message: message,
            type: 'request_update',
          );
        }
      }
    } catch (e) {
      throw Exception('Error updating request status: $e');
    }
  }

  /// Delete a request
  Future<void> deleteRequest(String requestId) async {
    try {
      await _db.collection('requests').doc(requestId).delete();
    } catch (e) {
      throw Exception('Error deleting request: $e');
    }
  }

  // ============ ANNOUNCEMENT OPERATIONS ============
  /// Create an announcement
  Future<String> createAnnouncement({
    required String title,
    required String body,
    required String createdBy,
  }) async {
    try {
      final docRef = _db.collection('announcements').doc();
      await docRef.set({
        'announcementId': docRef.id,
        'title': title,
        'body': body,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating announcement: $e');
    }
  }

  /// Get all announcements (real-time stream)
  Stream<List<Map<String, dynamic>>> getAnnouncementsStream() {
    try {
      return _db
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }

  /// Delete an announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await _db.collection('announcements').doc(announcementId).delete();
    } catch (e) {
      throw Exception('Error deleting announcement: $e');
    }
  }

  // ============ NOTIFICATION OPERATIONS ============
  /// Create a notification
  Future<String> createNotification({
    required String toUid,
    required String message,
    required String type,
  }) async {
    try {
      final docRef = _db.collection('notifications').doc();
      await docRef.set({
        'notificationId': docRef.id,
        'toUid': toUid,
        'message': message,
        'type': type,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating notification: $e');
    }
  }

  /// Get notifications for a user (real-time stream)
  Stream<List<Map<String, dynamic>>> getUserNotificationsStream(String uid) {
    try {
      return _db
          .collection('notifications')
          .where('toUid', isEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        final items = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return data;
        }).toList();

        // Sort client-side by createdAt (descending) to avoid index issues
        items.sort((a, b) {
          DateTime? aTime;
          DateTime? bTime;

          final aCreated = a['createdAt'];
          final bCreated = b['createdAt'];

          if (aCreated is Map && aCreated.containsKey('_seconds')) {
            aTime = DateTime.fromMillisecondsSinceEpoch((aCreated['_seconds'] as int) * 1000);
          } else if (aCreated is DateTime) {
            aTime = aCreated;
          } else if (aCreated != null) {
            try {
              // Timestamp from cloud_firestore
              final seconds = (aCreated as dynamic).seconds as int?;
              if (seconds != null) aTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
            } catch (_) {}
          }

          if (bCreated is Map && bCreated.containsKey('_seconds')) {
            bTime = DateTime.fromMillisecondsSinceEpoch((bCreated['_seconds'] as int) * 1000);
          } else if (bCreated is DateTime) {
            bTime = bCreated;
          } else if (bCreated != null) {
            try {
              final seconds = (bCreated as dynamic).seconds as int?;
              if (seconds != null) bTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
            } catch (_) {}
          }

          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });

        return items;
      });
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        'read': true,
      });
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      throw Exception('Error deleting notification: $e');
    }
  }

  /// Clear all notifications for a user
  Future<void> clearUserNotifications(String uid) async {
    try {
      final snapshot = await _db
          .collection('notifications')
          .where('toUid', isEqualTo: uid)
          .get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Error clearing notifications: $e');
    }
  }

  // ============ STORAGE OPERATIONS ============
  /// Upload image to Firebase Storage
  /// Returns the download URL
  Future<String> uploadImage({
    required File imageFile,
    required String folder,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Upload multiple images for a report
  /// Returns list of download URLs
  Future<List<String>> uploadReportImages({
    required List<File> imageFiles,
    required String reportId,
  }) async {
    try {
      final List<String> urls = [];
      for (int i = 0; i < imageFiles.length; i++) {
        final url = await uploadImage(
          imageFile: imageFiles[i],
          folder: 'reports/$reportId',
          fileName: 'photo_$i.jpg',
        );
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Error uploading report images: $e');
    }
  }

  /// Upload proof image for a request
  /// Returns download URL
  Future<String> uploadProofImage({
    required File imageFile,
    required String requestId,
  }) async {
    try {
      final url = await uploadImage(
        imageFile: imageFile,
        folder: 'requests/$requestId',
        fileName: 'proof.jpg',
      );
      return url;
    } catch (e) {
      throw Exception('Error uploading proof image: $e');
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  // ============ QUERY / ANALYTICS OPERATIONS ============
  /// Get count of reports by status
  Future<Map<String, int>> getReportStats() async {
    try {
      final snapshot = await _db.collection('reports').get();
      final stats = {
        'total': 0,
        'pending': 0,
        'inProgress': 0,
        'solved': 0,
      };

      for (final doc in snapshot.docs) {
        final status = doc['status'] as String?;
        stats['total'] = (stats['total'] ?? 0) + 1;
        if (status == 'Pending') stats['pending'] = (stats['pending'] ?? 0) + 1;
        if (status == 'In Progress') stats['inProgress'] = (stats['inProgress'] ?? 0) + 1;
        if (status == 'Solved') stats['solved'] = (stats['solved'] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Error fetching report stats: $e');
    }
  }

  /// Get count of requests by status
  Future<Map<String, int>> getRequestStats() async {
    try {
      final snapshot = await _db.collection('requests').get();
      final stats = {
        'total': 0,
        'pending': 0,
        'approved': 0,
        'rejected': 0,
      };

      for (final doc in snapshot.docs) {
        final status = doc['status'] as String?;
        stats['total'] = (stats['total'] ?? 0) + 1;
        if (status == 'Pending') stats['pending'] = (stats['pending'] ?? 0) + 1;
        if (status == 'Approved') stats['approved'] = (stats['approved'] ?? 0) + 1;
        if (status == 'Rejected') stats['rejected'] = (stats['rejected'] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Error fetching request stats: $e');
    }
  }

  /// Search reports by category
  Future<List<Map<String, dynamic>>> searchReportsByCategory(
      String category) async {
    try {
      final snapshot = await _db
          .collection('reports')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error searching reports: $e');
    }
  }
}
