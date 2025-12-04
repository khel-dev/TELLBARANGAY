import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/data_service.dart';

class ReportsOfficialPage extends StatefulWidget {
  const ReportsOfficialPage({Key? key}) : super(key: key);

  @override
  State<ReportsOfficialPage> createState() => _ReportsOfficialPageState();
}

class _ReportsOfficialPageState extends State<ReportsOfficialPage> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final allReports = DataService.instance.getReports();
    final filteredReports = selectedStatus == null
        ? allReports
        : allReports.where((r) => r['status'] == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Received Reports',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.paleOrange,
                  AppColors.primaryOrange,
                ],
              ),
            ),
          ),
          Column(
            children: [
              // Filter chips
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: selectedStatus == null,
                        onSelected: (selected) {
                          setState(() => selectedStatus = null);
                        },
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        selectedColor: AppColors.white,
                        labelStyle: TextStyle(
                          color: selectedStatus == null ? AppColors.primaryOrange : AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Pending'),
                        selected: selectedStatus == 'Pending',
                        onSelected: (selected) {
                          setState(() => selectedStatus = selected ? 'Pending' : null);
                        },
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        selectedColor: AppColors.accentRed.withOpacity(0.8),
                        labelStyle: TextStyle(
                          color: selectedStatus == 'Pending' ? AppColors.white : AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('In Progress'),
                        selected: selectedStatus == 'In Progress',
                        onSelected: (selected) {
                          setState(() => selectedStatus = selected ? 'In Progress' : null);
                        },
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        selectedColor: AppColors.brightBlue.withOpacity(0.8),
                        labelStyle: TextStyle(
                          color: selectedStatus == 'In Progress' ? AppColors.white : AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Solved'),
                        selected: selectedStatus == 'Solved',
                        onSelected: (selected) {
                          setState(() => selectedStatus = selected ? 'Solved' : null);
                        },
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        selectedColor: AppColors.brightGreen.withOpacity(0.8),
                        labelStyle: TextStyle(
                          color: selectedStatus == 'Solved' ? AppColors.white : AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Reports list
              Expanded(
                child: filteredReports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 64,
                              color: AppColors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No reports found',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = filteredReports[filteredReports.length - 1 - index];
                          return _buildReportCard(context, report);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, String> report) {
    final statusColor = report['status'] == 'Pending'
        ? AppColors.accentRed
        : report['status'] == 'In Progress'
            ? AppColors.brightBlue
            : AppColors.brightGreen;

    return GestureDetector(
      onTap: () => _showReportDetails(context, report),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left colored border indicator
              Container(
                width: 5,
                height: 80,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${report['id']?.substring(0, 8) ?? "N/A"}',
                          style: const TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: statusColor, width: 1),
                          ),
                          child: Text(
                            report['status'] ?? 'Pending',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      report['category'] ?? 'Report',
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (report['description']?.length ?? 0) > 60
                          ? '${report['description']!.substring(0, 60)}...'
                          : report['description'] ?? '',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(report['date'] ?? ''),
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action icon
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.primaryOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDetails(BuildContext context, Map<String, String> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Report #${report['id']?.substring(0, 8) ?? "N/A"}',
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.darkGrey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                report['category'] ?? 'Report',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailField('Status', report['status'] ?? 'Pending'),
              _buildDetailField('Reported by', report['fullName'] ?? 'Anonymous'),
              _buildDetailField('Date', _formatDate(report['date'] ?? '')),
              _buildDetailField('Description', report['description'] ?? ''),
              const SizedBox(height: 24),
              // Status update buttons
              Text(
                'Change Status',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        DataService.instance.updateReportStatus(report['id'] ?? '', 'In Progress');
                        Navigator.pop(context);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Status updated to In Progress'),
                            backgroundColor: AppColors.brightBlue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'In Progress',
                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        DataService.instance.updateReportStatus(report['id'] ?? '', 'Solved');
                        Navigator.pop(context);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Status updated to Solved'),
                            backgroundColor: AppColors.brightGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Solved',
                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryOrange,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return 'Unknown date';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }
}
