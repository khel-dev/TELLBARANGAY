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
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dashboard Analytics',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reports Summary
                Text(
                  'Reports Summary',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Total Reports',
                        value: '$totalReports',
                        icon: Icons.report_problem,
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Resolved',
                        value: '$solvedReports',
                        icon: Icons.check_circle,
                        color: AppColors.brightGreen,
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
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'In Progress',
                        value: '$inProgressReports',
                        icon: Icons.hourglass_top,
                        color: AppColors.brightBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Requests Summary
                Text(
                  'Requests Summary',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Total Requests',
                        value: '$totalRequests',
                        icon: Icons.assignment,
                        color: AppColors.brightBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Approved',
                        value: '$approvedRequests',
                        icon: Icons.thumb_up,
                        color: AppColors.brightGreen,
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
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Rejected',
                        value: '$rejectedRequests',
                        icon: Icons.thumb_down,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Performance Metrics
                Text(
                  'Performance Metrics',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _PerformanceCard(
                  title: 'Report Resolution Rate',
                  percentage: reportResolutionRate,
                  description: '$solvedReports out of $totalReports reports resolved',
                  color: AppColors.brightGreen,
                ),
                const SizedBox(height: 12),
                _PerformanceCard(
                  title: 'Request Approval Rate',
                  percentage: requestApprovalRate,
                  description: '$approvedRequests out of $totalRequests requests approved',
                  color: AppColors.brightBlue,
                ),
                const SizedBox(height: 24),
                // Key Insights
                Text(
                  'Key Insights',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _InsightBox(
                  icon: Icons.trending_up,
                  title: 'Most Common Report Type',
                  subtitle: _getMostCommonReportType(reports),
                  color: AppColors.brightGreen,
                ),
                const SizedBox(height: 8),
                _InsightBox(
                  icon: Icons.assessment,
                  title: 'System Status',
                  subtitle: totalReports > 0 ? 'Active' : 'No activity yet',
                  color: AppColors.brightBlue,
                ),
                const SizedBox(height: 8),
                _InsightBox(
                  icon: Icons.people,
                  title: 'Community Engagement',
                  subtitle: '${totalReports + totalRequests} total submissions',
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(height: 24),
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
    final maxCategory =
        categories.entries.reduce((a, b) => a.value > b.value ? a : b);
    return maxCategory.key;
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 12,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 12,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 12,
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
