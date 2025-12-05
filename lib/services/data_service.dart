// Service to manage submitted reports, requests, and user data
class DataService {
  DataService._private();
  static final DataService instance = DataService._private();

  // Store submitted reports
  final List<Map<String, String>> _reports = [];
  
  // Store submitted requests
  final List<Map<String, String>> _requests = [];

  // Store announcements
  final List<Map<String, String>> _announcements = [];

  // Store notifications for citizens
  final List<Map<String, String>> _notifications = [];

  // Submit a new report
  void submitReport(String category, String description, String fullName) {
    _reports.add({
      'id': 'RPT-${DateTime.now().millisecondsSinceEpoch}',
      'category': category,
      'description': description,
      'fullName': fullName,
      'status': 'Pending',
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Submit a new request
  void submitRequest(String type, String fullName, String purpose, [String? details]) {
    _requests.add({
      'id': 'REQ-${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'fullName': fullName,
      'purpose': purpose,
      'details': details ?? '',
      'status': 'Pending',
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Get all reports
  List<Map<String, String>> getReports() => List.from(_reports);

  // Get all requests
  List<Map<String, String>> getRequests() => List.from(_requests);

  // Update report status
  void updateReportStatus(String id, String status) {
    for (var report in _reports) {
      if (report['id'] == id) {
        report['status'] = status;
        // Create notification for citizen
        String message = 'Your report: "${report['category']}" is now $status. ';
        if (status == 'In Progress') {
          message += 'The barangay office is working on your concern.';
        } else if (status == 'Solved') {
          message += 'Your report has been resolved. Thank you for bringing this to our attention.';
        }
        _notifications.add({
          'id': 'NOT-${DateTime.now().millisecondsSinceEpoch}',
          'message': message,
          'reportId': id,
          'type': 'report_update',
          'timestamp': DateTime.now().toIso8601String(),
        });
        break;
      }
    }
  }

  // Update request status
  void updateRequestStatus(String id, String status) {
    for (var request in _requests) {
      if (request['id'] == id) {
        request['status'] = status;
        // Create notification for citizen
        String message = 'Your request for "${request['type']}" has been $status. ';
        if (status == 'Approved') {
          message += 'Great news! Your request has been approved. You can now claim your certificate at the barangay hall during office hours.';
        } else if (status == 'Rejected') {
          message += 'Your request could not be approved at this time. Please visit the barangay hall for more information.';
        } else if (status == 'Pending') {
          message += 'Your request is being processed by the barangay office.';
        }
        _notifications.add({
          'id': 'NOT-${DateTime.now().millisecondsSinceEpoch}',
          'message': message,
          'requestId': id,
          'type': 'request_update',
          'timestamp': DateTime.now().toIso8601String(),
        });
        break;
      }
    }
  }

  // Get single report by ID
  Map<String, String>? getReportById(String id) {
    try {
      return _reports.firstWhere((r) => r['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get single request by ID
  Map<String, String>? getRequestById(String id) {
    try {
      return _requests.firstWhere((r) => r['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Delete report by ID
  void deleteReport(String id) {
    _reports.removeWhere((r) => r['id'] == id);
  }

  // Delete request by ID
  void deleteRequest(String id) {
    _requests.removeWhere((r) => r['id'] == id);
  }

  // Update report
  void updateReport(String id, String category, String description) {
    for (var report in _reports) {
      if (report['id'] == id) {
        report['category'] = category;
        report['description'] = description;
        break;
      }
    }
  }

  // Update request
  void updateRequest(String id, String purpose, [String? details]) {
    for (var request in _requests) {
      if (request['id'] == id) {
        request['purpose'] = purpose;
        if (details != null) {
          request['details'] = details;
        }
        break;
      }
    }
  }

  // Add announcement
  void addAnnouncement(String title, String description) {
    _announcements.add({
      'id': 'ANN-${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'description': description,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Get all announcements
  List<Map<String, String>> getAnnouncements() => List.from(_announcements);

  // Update announcement
  void updateAnnouncement(String id, String title, String description) {
    for (var announcement in _announcements) {
      if (announcement['id'] == id) {
        announcement['title'] = title;
        announcement['description'] = description;
        break;
      }
    }
  }

  // Delete announcement
  void deleteAnnouncement(String id) {
    _announcements.removeWhere((a) => a['id'] == id);
  }

  // Get all notifications
  List<Map<String, String>> getNotifications() => List.from(_notifications);

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
  }

  // Delete single notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n['id'] == id);
  }
}
