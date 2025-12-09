import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  AuthService._private();
  static final AuthService instance = AuthService._private();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService.instance;

  Map<String, dynamic>? _currentUserData;

  /// Register a user with Firebase Auth and create profile in Firestore
  /// Returns error message on failure, null on success
  Future<String?> register(
    String email,
    String username,
    String password,
    String displayName, {
    String role = 'citizen',
    String? address,
    String? contact,
    String? barangay,
    String? age,
    String? position,
  }) async {
    try {
      if (email.isEmpty || username.isEmpty || password.length < 6) {
        return 'Please fill all required fields. Password must be at least 6 characters.';
      }

      // Check if username already exists in Firestore
      final usernameExists = await _db.checkUsernameExists(username);
      if (usernameExists) {
        return 'Username already exists. Please choose a different username.';
      }

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Create user profile in Firestore with username
      await _db.createUserProfile(
        uid: uid,
        name: displayName,
        email: email,
        role: role,
        position: position,
        username: username,
        address: address,
        contact: contact,
        barangay: barangay,
        age: age,
      );

      // Load and cache user data
      _currentUserData = await _db.getUserProfile(uid);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'email-already-in-use') {
        return 'Email is already registered. Please use a different email or login.';
      } else if (e.code == 'weak-password') {
        return 'Password is too weak. Please use a stronger password.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address. Please check your email format.';
      } else if (e.code == 'network-request-failed') {
        return 'Network error. Please check your internet connection.';
      } else {
        return 'Registration failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      print('Registration error: $e');
      return 'Registration failed: ${e.toString()}';
    }
  }

  /// Login with email and password
  /// Returns error message on failure, null on success
  Future<String?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please enter your email and password.';
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      _currentUserData = await _db.getUserProfile(uid);
      
      if (_currentUserData == null) {
        return 'User profile not found. Please contact support.';
      }
      
      return null; // Success
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'user-not-found') {
        return 'No account found with this email. Please register first.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address. Please check your email format.';
      } else if (e.code == 'user-disabled') {
        return 'This account has been disabled. Please contact support.';
      } else if (e.code == 'network-request-failed') {
        return 'Network error. Please check your internet connection.';
      } else {
        return 'Login failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      print('Login error: $e');
      return 'Login failed: ${e.toString()}';
    }
  }

  /// Logout from Firebase
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUserData = null;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Get current user data
  Map<String, dynamic>? get currentUser {
    return _currentUserData;
  }

  /// Get current Firebase user
  User? get firebaseUser => _auth.currentUser;

  /// Get current user's role
  String get currentUserRole {
    return _currentUserData?['role'] ?? 'citizen';
  }

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null && _currentUserData != null;

  /// Get current user's UID
  String? get currentUid => _auth.currentUser?.uid;

  /// Refresh current user data from Firestore
  Future<void> refreshCurrentUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        _currentUserData = await _db.getUserProfile(uid);
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  /// Reset password (Firebase built-in)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }
}
