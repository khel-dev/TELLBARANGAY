import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/database.dart';

class RequestsOfficialPage extends StatefulWidget {
  const RequestsOfficialPage({Key? key}) : super(key: key);

  @override
  State<RequestsOfficialPage> createState() => _RequestsOfficialPageState();
}

class _RequestsOfficialPageState extends State<RequestsOfficialPage> {
  String? selectedStatus;
  final DatabaseService _db = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Requests to Process',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _db.getRequestsStream(),
                      builder: (context, snapshot) {
                        final count = snapshot.hasData ? snapshot.data!.length : 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count Total',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: selectedStatus == null,
                        onTap: () => setState(() => selectedStatus = null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Pending',
                        isSelected: selectedStatus == 'Pending',
                        onTap: () => setState(() => selectedStatus = 'Pending'),
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Approved',
                        isSelected: selectedStatus == 'Approved',
                        onTap: () => setState(() => selectedStatus = 'Approved'),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Rejected',
                        isSelected: selectedStatus == 'Rejected',
                        onTap: () => setState(() => selectedStatus = 'Rejected'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),

              // Requests list
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _db.getRequestsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: AppColors.white.withOpacity(0.7)),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading requests: ${snapshot.error}',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final allRequests = snapshot.data ?? [];
                    final filteredRequests = selectedStatus == null
                        ? allRequests
                        : allRequests.where((r) => r['status'] == selectedStatus).toList();

                    if (filteredRequests.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: AppColors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No requests found',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return _buildRequestCard(context, request);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> request) {
    final statusColor = request['status'] == 'Pending'
        ? Colors.orange
        : request['status'] == 'Approved'
            ? Colors.green
            : Colors.red;

    return GestureDetector(
      onTap: () => _showRequestDetails(context, request),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['type']?.toString() ?? 'Request',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From: ${request['fullName']?.toString() ?? 'Unknown'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
                      request['status']?.toString() ?? 'Pending',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (request['purpose'] != null && request['purpose'].toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  (request['purpose']?.toString().length ?? 0) > 100
                      ? '${request['purpose'].toString().substring(0, 100)}...'
                      : request['purpose']?.toString() ?? '',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(request['createdAt']),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '#${request['id']?.toString().substring(0, 8) ?? "N/A"}',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryOrange),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Request Details',
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.black87, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Type', request['type']?.toString() ?? 'N/A', Icons.category),
              const SizedBox(height: 16),
              _buildDetailRow('Status', request['status']?.toString() ?? 'Pending', Icons.info),
              const SizedBox(height: 16),
              _buildDetailRow('Requested by', request['fullName']?.toString() ?? 'Unknown', Icons.person),
              const SizedBox(height: 16),
              _buildDetailRow('Date', _formatDate(request['createdAt']), Icons.calendar_today),
              const SizedBox(height: 16),
              _buildDetailRow('Reference', '#${request['id']?.toString().substring(0, 12) ?? "N/A"}', Icons.tag),
              if (request['purpose'] != null && request['purpose'].toString().isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Purpose',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request['purpose']?.toString() ?? '',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              if (request['proofUrl'] != null && request['proofUrl'].toString().isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Proof Document',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    request['proofUrl'].toString(),
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.grey[600], size: 48),
                              const SizedBox(height: 8),
                              Text('Failed to load image', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Take Action',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              if (request['status'] == 'Pending') ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _db.updateRequestStatus(request['id'].toString(), 'Approved');
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Request approved'),
                              backgroundColor: AppColors.brightGreen,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppColors.accentRed,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Approve Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _db.updateRequestStatus(request['id'].toString(), 'Rejected');
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Request rejected'),
                              backgroundColor: AppColors.accentRed,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppColors.accentRed,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Reject Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (request['status'] == 'Approved' ? Colors.green : Colors.red).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        request['status'] == 'Approved' ? Icons.check_circle : Icons.cancel,
                        color: request['status'] == 'Approved' ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This request has been ${request['status']?.toString().toLowerCase()}',
                          style: TextStyle(
                            color: request['status'] == 'Approved' ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryOrange, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';
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
          return 'Unknown date';
        }
      } else {
        return 'Unknown date';
      }
      
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (color != null ? color!.withOpacity(0.2) : AppColors.white)
              : AppColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primaryOrange)
                : AppColors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (color ?? AppColors.primaryOrange)
                : AppColors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
