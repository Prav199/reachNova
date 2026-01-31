import 'package:flutter/material.dart';
import 'package:reachnova/models/application.dart';
import 'package:reachnova/models/campaign.dart';
import 'package:reachnova/repositories/auth_repository.dart';
import 'package:reachnova/repositories/campaign_repository.dart';
import 'package:reachnova/theme/app_colors.dart';
import 'package:reachnova/theme/app_theme.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with AutomaticKeepAliveClientMixin {
  final CampaignRepository _campaignRepository = CampaignRepository();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = true;
  final Map<String, Campaign> _campaignsMap = {};
  List<Application> _applications = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authRepository.getCurrentUser();
      final applications = await _campaignRepository.fetchUserApplications(
        user.id,
      );

      // Also fetch campaign details for each application
      for (var app in applications) {
        if (!_campaignsMap.containsKey(app.campaignId)) {
          final campaign = await _campaignRepository.fetchCampaignDetails(
            app.campaignId,
          );
          _campaignsMap[app.campaignId] = campaign;
        }
      }

      // Sort by newest first
      applications.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));

      if (mounted) {
        setState(() {
          _applications = applications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('Error loading applications: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.lightest,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox(), // Remove default back button
          leadingWidth: 0,
          title: const Text(
            'My Activity',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.dark,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.dark,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildApplicationList(_applications),
                  _buildApplicationList(
                    _applications
                        .where((a) => a.status == ApplicationStatus.pending)
                        .toList(),
                  ),
                  _buildApplicationList(
                    _applications
                        .where((a) => a.status == ApplicationStatus.accepted)
                        .toList(),
                  ),
                  _buildApplicationList(
                    _applications
                        .where((a) => a.status == ApplicationStatus.rejected)
                        .toList(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildApplicationList(List<Application> applications) {
    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        final campaign = _campaignsMap[application.campaignId];

        if (campaign == null) return const SizedBox();

        return _buildEnhancedApplicationCard(application, campaign);
      },
    );
  }

  Widget _buildEnhancedApplicationCard(
    Application application,
    Campaign campaign,
  ) {
    Color statusColor;
    Color statusBgColor;
    String statusText;

    switch (application.status) {
      case ApplicationStatus.accepted:
        statusColor = Colors.green.shade700;
        statusBgColor = Colors.green.shade50;
        statusText = 'Accepted';
        break;
      case ApplicationStatus.rejected:
        statusColor = Colors.red.shade700;
        statusBgColor = Colors.red.shade50;
        statusText = 'Rejected';
        break;
      case ApplicationStatus.pending:
        statusColor = Colors.orange.shade800;
        statusBgColor = Colors.orange.shade50;
        statusText = 'Pending';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    campaign.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              campaign.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.dark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            campaign.platform == 'Instagram'
                                ? Icons.camera_alt_outlined
                                : Icons.play_circle_outline,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        campaign.brandName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(application.appliedDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Potential Earnings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '₹${campaign.budget.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
                if (application.status == ApplicationStatus.accepted)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Open Chat'),
                  )
                else
                  TextButton(
                    onPressed: () {
                      // Navigate to details or show withdrawal option
                    },
                    child: Text(
                      'View Details',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      return 'Today';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
