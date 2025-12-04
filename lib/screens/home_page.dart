import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final displayName = user != null && user['name']!.isNotEmpty
        ? user['name']!
        : 'Citizen';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '🏘️',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'TellBarangay',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryOrange, AppColors.darkOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.paleOrange,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, $displayName!',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check your reports and stay updated with barangay announcements.',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text('Quick actions', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _ActionTile(
                      title: 'Report an Issue',
                      description: 'Garbage, noise, safety, and more.',
                      icon: Icons.warning_amber,
                      color: const Color(0xFFFFF3E0),
                      onTap: () => Navigator.pushNamed(context, '/reports'),
                    ),
                    _ActionTile(
                      title: 'Submit a Request',
                      description: 'Clearances, IDs, certificates.',
                      icon: Icons.assignment,
                      color: const Color(0xFFFFEBEE),
                      onTap: () => Navigator.pushNamed(context, '/request'),
                    ),
                    _ActionTile(
                      title: 'Track My Reports',
                      description: 'Check status and history.',
                      icon: Icons.schedule,
                      color: const Color(0xFFF3E5F5),
                      onTap: () => Navigator.pushNamed(context, '/track'),
                    ),
                    _ActionTile(
                      title: 'Announcements',
                      description: 'Updates from your barangay.',
                      icon: Icons.announcement,
                      color: const Color(0xFFE3F2FD),
                      onTap: () => Navigator.pushNamed(context, '/announcements'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text('Recent reports', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: [
                      _ReportCard(title: 'Uncollected garbage along Purok 5', status: 'Pending'),
                      _ReportCard(title: 'Streetlight not working at corner', status: 'In progress'),
                      _ReportCard(title: 'Loud noise complaint resolved', status: 'Resolved'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 32),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: AppColors.primaryOrange.withOpacity(0.7),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String status;

  const _ReportCard({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    Color badgeColor = status == 'Pending' ? Colors.orange : (status == 'Resolved' ? Colors.green : Colors.blue);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Text(status, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
