import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';
import '../services/database.dart';

class HomeOfficialPage extends StatelessWidget {
  const HomeOfficialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final displayName = user != null && user['name']!.isNotEmpty
        ? user['name']!
        : 'Official';
    final db = DatabaseService.instance;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section - Light orange card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.paleOrange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Logo on left
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.primaryOrange,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/TELLBARANGAY_LOGO.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.admin_panel_settings, color: AppColors.primaryOrange, size: 28);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting and name in center
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Official!',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user?['position'] != null && user!['position']!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                user['position']!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Profile icon on right
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Icon(Icons.person, color: Colors.grey[600], size: 24),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Stats',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: db.getReportsStream(),
                        builder: (context, reportsSnapshot) {
                          final reports = reportsSnapshot.data ?? [];
                          final pendingReports = reports.where((r) => r['status'] == 'Pending').length;
                          final inProgressReports = reports.where((r) => r['status'] == 'In Progress').length;
                          final solvedReports = reports.where((r) => r['status'] == 'Solved').length;
                          
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: db.getRequestsStream(),
                            builder: (context, requestsSnapshot) {
                              final requests = requestsSnapshot.data ?? [];
                              final pendingRequests = requests.where((r) => r['status'] == 'Pending').length;
                              
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _StatCard(
                                          title: 'Pending Reports',
                                          count: pendingReports,
                                          icon: Icons.report_problem,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _StatCard(
                                          title: 'Pending Requests',
                                          count: pendingRequests,
                                          icon: Icons.assignment,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _StatCard(
                                          title: 'In Progress',
                                          count: inProgressReports,
                                          icon: Icons.hourglass_top,
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _StatCard(
                                          title: 'Solved',
                                          count: solvedReports,
                                          icon: Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick Actions Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: db.getReportsStream(),
                        builder: (context, reportsSnapshot) {
                          final reports = reportsSnapshot.data ?? [];
                          final pendingReports = reports.where((r) => r['status'] == 'Pending').length;
                          
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: db.getRequestsStream(),
                            builder: (context, requestsSnapshot) {
                              final requests = requestsSnapshot.data ?? [];
                              final pendingRequests = requests.where((r) => r['status'] == 'Pending').length;
                              
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                                children: [
                                  _ActionCard(
                                    title: 'Received Reports',
                                    description: 'View & resolve citizen reports',
                                    icon: Icons.report_problem,
                                    iconColor: Colors.red,
                                    onTap: () => Navigator.pushNamed(context, '/official-reports'),
                                    badgeCount: pendingReports > 0 ? pendingReports : null,
                                  ),
                                  _ActionCard(
                                    title: 'Requests to Process',
                                    description: 'Approve or reject requests',
                                    icon: Icons.assignment_turned_in,
                                    iconColor: Colors.blue,
                                    onTap: () => Navigator.pushNamed(context, '/official-requests'),
                                    badgeCount: pendingRequests > 0 ? pendingRequests : null,
                                  ),
                                  _ActionCard(
                                    title: 'Post Announcements',
                                    description: 'Share barangay updates',
                                    icon: Icons.campaign,
                                    iconColor: Colors.purple,
                                    onTap: () => Navigator.pushNamed(context, '/official-announcements'),
                                  ),
                                  _ActionCard(
                                    title: 'Analytics',
                                    description: 'View dashboard stats',
                                    icon: Icons.bar_chart,
                                    iconColor: Colors.orange,
                                    onTap: () => Navigator.pushNamed(context, '/official-analytics'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recent Activity Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: db.getReportsStream(),
                        builder: (context, reportsSnapshot) {
                          final reports = reportsSnapshot.data ?? [];
                          
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: db.getRequestsStream(),
                            builder: (context, requestsSnapshot) {
                              final requests = requestsSnapshot.data ?? [];
                              
                              if (reports.isEmpty && requests.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No recent activity',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              
                              return Column(
                                children: [
                                  if (reports.isNotEmpty)
                                    _ActivityCard(
                                      title: reports.first['title']?.toString() ?? reports.first['category']?.toString() ?? 'Report',
                                      subtitle: 'Category: ${reports.first['category']?.toString() ?? 'N/A'}',
                                      timestamp: _formatTime(reports.first['createdAt']),
                                      status: reports.first['status']?.toString() ?? 'Pending',
                                      type: 'report',
                                    ),
                                  if (requests.isNotEmpty) ...[
                                    if (reports.isNotEmpty) const SizedBox(height: 12),
                                    _ActivityCard(
                                      title: requests.first['type']?.toString() ?? 'Request',
                                      subtitle: 'From: ${requests.first['fullName']?.toString() ?? 'Citizen'}',
                                      timestamp: _formatTime(requests.first['createdAt']),
                                      status: requests.first['status']?.toString() ?? 'Pending',
                                      type: 'request',
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(dynamic date) {
    if (date == null) return 'Just now';
    try {
      DateTime dateTime;
      if (date is DateTime) {
        dateTime = date;
      } else if (date is Map) {
        // Firestore Timestamp
        final seconds = date['_seconds'] as int?;
        if (seconds != null) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        } else {
          return 'Just now';
        }
      } else {
        return 'Just now';
      }
      
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Just now';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                '$count',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final int? badgeCount;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount! > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;
  final String status;
  final String type;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Pending'
        ? Colors.orange
        : status == 'In Progress' || status == 'Approved'
            ? Colors.lightBlue
            : status == 'Solved'
                ? Colors.green
                : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: type == 'report' ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              type == 'report' ? Icons.report_problem : Icons.assignment,
              color: type == 'report' ? Colors.red : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
