// Service to manage submitted reports, requests, and user data
class DataService {
  DataService._private();
  static final DataService instance = DataService._private();

  // Store submitted reports
  final List<Map<String, String>> _reports = [];
  
  // Store submitted requests
  final List<Map<String, String>> _requests = [];

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
        break;
      }
    }
  }

  // Update request status
  void updateRequestStatus(String id, String status) {
    for (var request in _requests) {
      if (request['id'] == id) {
        request['status'] = status;
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
}
