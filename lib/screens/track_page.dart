import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/data_service.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({Key? key}) : super(key: key);

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Track My Reports',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          indicatorWeight: 3,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.6),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Reports'),
            Tab(text: 'Requests'),
          ],
        ),
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
          TabBarView(
            controller: _tabController,
            children: [
              _buildReportsTab(),
              _buildRequestsTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    final reports = DataService.instance.getReports();
    return _buildItemsList(reports, 'Reports', isReports: true);
  }

  Widget _buildRequestsTab() {
    final requests = DataService.instance.getRequests();
    return _buildItemsList(requests, 'Requests', isReports: false);
  }

  Widget _buildItemsList(List<Map<String, String>> items, String type,
      {required bool isReports}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isReports ? Icons.assignment : Icons.description,
              size: 64,
              color: AppColors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No $type yet',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your submitted $type will appear here',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[items.length - 1 - index]; // Reverse order (newest first)
        final status = item['status'] ?? 'Pending';
        final statusColor = status == 'Solved'
            ? AppColors.brightGreen
            : (status == 'In Progress'
                ? AppColors.brightBlue
                : AppColors.accentRed);

        return GestureDetector(
          onTap: isReports ? null : () => _showRequestDetails(context, item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Stack(
              children: [
                // Colored left border
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with ID and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['id'] ?? 'N/A',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor, width: 1),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Type/Category
                      Text(
                        isReports
                            ? item['category'] ?? 'N/A'
                            : item['type'] ?? 'N/A',
                        style: const TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description/Purpose
                      Text(
                        isReports
                            ? (item['description'] ?? '').length > 80
                                ? '${(item['description'] ?? '').substring(0, 80)}...'
                                : (item['description'] ?? '')
                            : (item['purpose'] ?? '').length > 80
                                ? '${(item['purpose'] ?? '').substring(0, 80)}...'
                                : (item['purpose'] ?? ''),
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Footer with date and action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 13,
                                color: AppColors.lightGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDate(item['date'] ?? ''),
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Edit button
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: AppColors.brightBlue,
                                  ),
                                  onPressed: () => _showEditDialog(
                                    context,
                                    item,
                                    isReports,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Delete button
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: AppColors.accentRed,
                                  ),
                                  onPressed: () => _showDeleteConfirmation(
                                    context,
                                    item,
                                    isReports,
                                  ),
                                ),
                              ),
                              if (!isReports)
                                const SizedBox(width: 4),
                              if (!isReports)
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColors.primaryOrange,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRequestDetails(BuildContext context, Map<String, String> request) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request['type'] ?? 'Request Details',
                  style: const TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.darkGrey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailField('Request ID', request['id'] ?? 'N/A'),
            _buildDetailField('Full Name', request['fullName'] ?? 'N/A'),
            _buildDetailField('Type', request['type'] ?? 'N/A'),
            _buildDetailField('Purpose', request['purpose'] ?? 'N/A'),
            _buildDetailField('Status', request['status'] ?? 'N/A'),
            _buildDetailField('Submitted', _formatDate(request['date'] ?? '')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, String> item,
    bool isReports,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text(
          'Are you sure you want to delete this ${isReports ? 'report' : 'request'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isReports) {
                DataService.instance.deleteReport(item['id'] ?? '');
              } else {
                DataService.instance.deleteRequest(item['id'] ?? '');
              }
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${isReports ? 'Report' : 'Request'} deleted successfully',
                  ),
                  backgroundColor: AppColors.brightGreen,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.accentRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    Map<String, String> item,
    bool isReports,
  ) {
    final categoryController = TextEditingController(
      text: isReports ? item['category'] : item['type'],
    );
    final descriptionController = TextEditingController(
      text: isReports ? item['description'] : item['purpose'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${isReports ? 'Report' : 'Request'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: isReports ? 'Category' : 'Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: isReports ? 'Description' : 'Purpose',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isReports) {
                DataService.instance.updateReport(
                  item['id'] ?? '',
                  categoryController.text,
                  descriptionController.text,
                );
              } else {
                DataService.instance.updateRequest(
                  item['id'] ?? '',
                  descriptionController.text,
                );
              }
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${isReports ? 'Report' : 'Request'} updated successfully',
                  ),
                  backgroundColor: AppColors.brightGreen,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
