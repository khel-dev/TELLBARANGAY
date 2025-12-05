import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/data_service.dart';

class AnalyticsOfficialPage extends StatelessWidget {
  const AnalyticsOfficialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reports = DataService.instance.getReports();
    final requests = DataService.instance.getRequests();

    final totalReports = reports.length;
    final solvedReports = reports.where((r) => r['status'] == 'Solved').length;
    final pendingReports = reports.where((r) => r['status'] == 'Pending').length;
    final inProgressReports = reports.where((r) => r['status'] == 'In Progress').length;

    final totalRequests = requests.length;
    final approvedRequests = requests.where((r) => r['status'] == 'Approved').length;
    final pendingRequests = requests.where((r) => r['status'] == 'Pending').length;
    final rejectedRequests = requests.where((r) => r['status'] == 'Rejected').length;

    final reportResolutionRate = totalReports == 0 ? 0 : ((solvedReports / totalReports) * 100).toInt();
    final requestApprovalRate = totalRequests == 0 ? 0 : ((approvedRequests / totalRequests) * 100).toInt();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Dashboard Analytics',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Reports Summary
                _SectionHeader(title: 'Reports Summary', icon: Icons.report_problem),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Total Reports',
                        value: '$totalReports',
                        icon: Icons.report_problem,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Resolved',
                        value: '$solvedReports',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Pending',
                        value: '$pendingReports',
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'In Progress',
                        value: '$inProgressReports',
                        icon: Icons.hourglass_top,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Requests Summary
                _SectionHeader(title: 'Requests Summary', icon: Icons.assignment),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Total Requests',
                        value: '$totalRequests',
                        icon: Icons.assignment,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Approved',
                        value: '$approvedRequests',
                        icon: Icons.thumb_up,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Pending',
                        value: '$pendingRequests',
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Rejected',
                        value: '$rejectedRequests',
                        icon: Icons.thumb_down,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Performance Metrics
                _SectionHeader(title: 'Performance Metrics', icon: Icons.trending_up),
                const SizedBox(height: 12),
                _PerformanceCard(
                  title: 'Report Resolution Rate',
                  percentage: reportResolutionRate,
                  description: '$solvedReports out of $totalReports reports resolved',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _PerformanceCard(
                  title: 'Request Approval Rate',
                  percentage: requestApprovalRate,
                  description: '$approvedRequests out of $totalRequests requests approved',
                  color: Colors.blue,
                ),

                const SizedBox(height: 24),

                // Key Insights
                _SectionHeader(title: 'Key Insights', icon: Icons.lightbulb),
                const SizedBox(height: 12),
                _InsightBox(
                  icon: Icons.trending_up,
                  title: 'Most Common Report Type',
                  subtitle: _getMostCommonReportType(reports),
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _InsightBox(
                  icon: Icons.assessment,
                  title: 'System Status',
                  subtitle: totalReports > 0 || totalRequests > 0 ? 'Active' : 'No activity yet',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _InsightBox(
                  icon: Icons.people,
                  title: 'Community Engagement',
                  subtitle: '${totalReports + totalRequests} total submissions',
                  color: AppColors.primaryOrange,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMostCommonReportType(List<Map<String, String>> reports) {
    if (reports.isEmpty) return 'N/A';
    final categories = <String, int>{};
    for (final report in reports) {
      final category = report['category'] ?? 'Other';
      categories[category] = (categories[category] ?? 0) + 1;
    }
    if (categories.isEmpty) return 'N/A';
    final maxCategory =
        categories.entries.reduce((a, b) => a.value > b.value ? a : b);
    return maxCategory.key;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final String title;
  final int percentage;
  final String description;
  final Color color;

  const _PerformanceCard({
    required this.title,
    required this.percentage,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InsightBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
