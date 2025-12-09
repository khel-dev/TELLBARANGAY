import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';
import '../services/database.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final DatabaseService _db = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final displayName = user != null && user['name']!.isNotEmpty
        ? user['name']!
        : 'Citizen';
    final currentUid = AuthService.instance.currentUid;

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
                              return Icon(Icons.home, color: AppColors.primaryOrange, size: 28);
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
                              'Hello, Citizen!',
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
                          ],
                        ),
                      ),
                      // Bell icon and profile picture on right
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: currentUid != null ? _db.getUserNotificationsStream(currentUid) : Stream.value([]),
                        builder: (context, snapshot) {
                          final unreadCount = snapshot.hasData 
                              ? snapshot.data!.where((n) => n['read'] == false).length 
                              : 0;
                          
                          return Stack(
                            children: [
                              IconButton(
                                icon: Icon(
                                  unreadCount > 0 ? Icons.notifications : Icons.notifications_outlined,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  if (currentUid == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please login first')),
                                    );
                                    return;
                                  }
                                  
                                  final notifications = snapshot.data ?? [];
                                  if (notifications.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('No new notifications')),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Container(
                                        margin: const EdgeInsets.all(20),
                                        child: AlertDialog(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Notifications'),
                                              TextButton(
                                                onPressed: () async {
                                                  // Mark all as read
                                                  for (final notif in notifications) {
                                                    if (notif['read'] == false) {
                                                      await _db.markNotificationAsRead(notif['id'].toString());
                                                    }
                                                  }
                                                  if (context.mounted) Navigator.pop(context);
                                                },
                                                child: const Text('Mark all read', style: TextStyle(fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: notifications.length,
                                              itemBuilder: (context, index) {
                                                final notif = notifications[index];
                                                final isRead = notif['read'] == true;
                                                return GestureDetector(
                                                  onTap: () async {
                                                    if (!isRead) {
                                                      await _db.markNotificationAsRead(notif['id'].toString());
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: !isRead ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                notif['message']?.toString() ?? '',
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight: !isRead ? FontWeight.w600 : FontWeight.normal,
                                                                ),
                                                              ),
                                                            ),
                                                            if (!isRead)
                                                              Container(
                                                                width: 8,
                                                                height: 8,
                                                                decoration: const BoxDecoration(
                                                                  color: Colors.blue,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          _formatNotifTime(notif['createdAt']),
                                                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                                        ),
                                                        if (index < notifications.length - 1)
                                                          Divider(color: Colors.grey[300], height: 16),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount > 9 ? '9+' : '$unreadCount',
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
                          );
                        },
                      ),
                      const SizedBox(width: 8),
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

                // Quick actions section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick actions',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                        children: [
                          _ActionCard(
                            title: 'Report an Issue',
                            description: 'Garbage, noise, safety, and more.',
                            icon: Icons.warning_amber,
                            iconColor: Colors.red,
                            onTap: () => Navigator.pushNamed(context, '/reports'),
                            showNewBadge: true,
                          ),
                          _ActionCard(
                            title: 'Submit a Request',
                            description: 'Clearances, IDs, certificates.',
                            icon: Icons.description,
                            iconColor: Colors.blue,
                            onTap: () => Navigator.pushNamed(context, '/request'),
                          ),
                          _ActionCard(
                            title: 'Track My Reports',
                            description: 'Check status and history.',
                            icon: Icons.access_time,
                            iconColor: Colors.green,
                            onTap: () => Navigator.pushNamed(context, '/track'),
                          ),
                          _ActionCard(
                            title: 'Announcements',
                            description: 'Updates from your barangay.',
                            icon: Icons.campaign,
                            iconColor: Colors.purple,
                            onTap: () => Navigator.pushNamed(context, '/announcements'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Weather advisory section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paleOrange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrange,
                          ),
                          child: const Icon(
                            Icons.warning_amber,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weather advisory for Davao City',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Expect heavy rains this evening. Secure loose items and avoid flooded streets.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Recent reports section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent reports',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ReportCard(
                        title: 'Uncollected garbage along Purok 5',
                        reference: 'Ref: TB-2025-00123',
                        timestamp: '2 hours ago',
                        status: 'Pending',
                        statusColor: Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _ReportCard(
                        title: 'Streetlight not working at corner',
                        reference: 'Ref: TB-2025-00110',
                        timestamp: 'Yesterday',
                        status: 'In progress',
                        statusColor: Colors.lightBlue,
                      ),
                      const SizedBox(height: 12),
                      _ReportCard(
                        title: 'Loud noise complaint resolved',
                        reference: 'Ref: TB-2025-00098',
                        timestamp: '3 days ago',
                        status: 'Resolved',
                        statusColor: Colors.green,
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

  String _formatNotifTime(dynamic date) {
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

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showNewBadge;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.showNewBadge = false,
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
            if (showNewBadge)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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

class _ReportCard extends StatelessWidget {
  final String title;
  final String reference;
  final String timestamp;
  final String status;
  final Color statusColor;

  const _ReportCard({
    required this.title,
    required this.reference,
    required this.timestamp,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      reference,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: Colors.grey[600],
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
        ],
      ),
    );
  }
}
