class AuthService {
  AuthService._private();
  static final AuthService instance = AuthService._private();

  // email -> user map
  final Map<String, Map<String, String>> _users = {};
  // username -> email
  final Map<String, String> _usernameToEmail = {};
  String? _currentEmail;

  /// Register a user. Returns true on success. Username and email must be unique.
  /// role: 'citizen' or 'official'
  bool register(String email, String username, String password, String displayName, {String role = 'citizen'}) {
    if (email.isEmpty || username.isEmpty || password.length < 6) return false;
    if (_users.containsKey(email)) return false;
    if (_usernameToEmail.containsKey(username)) return false;

    _users[email] = {
      'email': email,
      'username': username,
      'password': password,
      'name': displayName,
      'role': role,
    };
    _usernameToEmail[username] = email;
    _currentEmail = email;
    return true;
  }

  /// Login with either email or username + password.
  bool login(String identifier, String password) {
    String? email;
    if (identifier.contains('@')) {
      email = identifier;
    } else {
      email = _usernameToEmail[identifier];
    }
    if (email == null) return false;
    final user = _users[email];
    if (user == null) return false;
    if (user['password'] != password) return false;
    _currentEmail = email;
    return true;
  }

  void logout() {
    _currentEmail = null;
  }

  Map<String, String>? get currentUser {
    if (_currentEmail == null) return null;
    return _users[_currentEmail!];
  }

  String get currentUserRole {
    final user = currentUser;
    return user?['role'] ?? 'citizen';
  }
}
