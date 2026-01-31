import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reachnova/providers/user_provider.dart';
import 'package:reachnova/models/campaign.dart';
import 'package:reachnova/repositories/campaign_repository.dart';
import 'package:reachnova/screens/applications_screen.dart';
import 'package:reachnova/screens/notifications_screen.dart';
import 'package:reachnova/screens/profile_screen.dart';
import 'package:reachnova/screens/details_screen.dart';
import 'package:reachnova/theme/app_colors.dart';
import 'package:reachnova/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final CampaignRepository _campaignRepository = CampaignRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedPlatform = 'All';
  String _searchQuery = '';
  List<Campaign> _allCampaigns = [];
  bool _isLoading = true;
  RangeValues _selectedBudgetRange = const RangeValues(0, 50000);
  String _sortBy = 'Newest';

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() => _isLoading = true);
    try {
      final campaigns = await _campaignRepository.fetchCampaigns();
      if (mounted) {
        setState(() {
          _allCampaigns = campaigns;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Campaign> get _filteredCampaigns {
    var filtered = _allCampaigns.where((campaign) {
      final matchesPlatform =
          _selectedPlatform == 'All' || campaign.platform == _selectedPlatform;
      final matchesSearch =
          campaign.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          campaign.brandName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesBudget =
          campaign.budget >= _selectedBudgetRange.start &&
          campaign.budget <= _selectedBudgetRange.end;
      return matchesPlatform && matchesSearch && matchesBudget;
    }).toList();

    switch (_sortBy) {
      case 'Budget: High to Low':
        filtered.sort((a, b) => b.budget.compareTo(a.budget));
        break;
      case 'Budget: Low to High':
        filtered.sort((a, b) => a.budget.compareTo(b.budget));
        break;
      case 'Newest':
      default:
        // Assuming newer campaigns are added later or we could sort by ID/date if available
        // For now, keep original order which we assume is newest first or just by ID
        break;
    }

    return filtered;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedBudgetRange = const RangeValues(
                                0,
                                50000,
                              );
                              _sortBy = 'Newest';
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Budget Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _selectedBudgetRange,
                      min: 0,
                      max: 50000,
                      divisions: 100,
                      activeColor: AppColors.dark,
                      inactiveColor: AppColors.light,
                      labels: RangeLabels(
                        '₹${_selectedBudgetRange.start.round()}',
                        '₹${_selectedBudgetRange.end.round()}',
                      ),
                      onChanged: (values) {
                        setModalState(() => _selectedBudgetRange = values);
                        setState(() {});
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${_selectedBudgetRange.start.round()}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          '₹${_selectedBudgetRange.end.round()}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSortChip('Newest', _sortBy == 'Newest', (val) {
                          setModalState(() => _sortBy = val);
                          setState(() {});
                        }),
                        _buildSortChip(
                          'Budget: High to Low',
                          _sortBy == 'Budget: High to Low',
                          (val) {
                            setModalState(() => _sortBy = val);
                            setState(() {});
                          },
                        ),
                        _buildSortChip(
                          'Budget: Low to High',
                          _sortBy == 'Budget: Low to High',
                          (val) {
                            setModalState(() => _sortBy = val);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(
    String label,
    bool isSelected,
    Function(String) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(label),
      selectedColor: AppColors.mediumLight,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.dark : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.dark : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightest,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeFeed(),
            const ApplicationsScreen(),
            const Center(child: Text("Chat - Coming Soon")),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: AppTheme.diffuseShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, 'Home', 0),
            _buildNavItem(Icons.assignment_outlined, 'Applications', 1),
            _buildNavItem(Icons.chat_bubble_outline, 'Chat', 2),
            _buildNavItem(Icons.person_outline, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeFeed() {
    return RefreshIndicator(
      onRefresh: _loadCampaigns,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final userName =
                          userProvider.user?.name.split(' ').first ?? 'Arjun';
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $userName',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Find Your Next\nCampaign',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  color: AppColors.dark,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: AppTheme.softShadow,
                              ),
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            decoration: const InputDecoration(
                              hintText: 'Search brands or campaigns...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showFilterDialog,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Platform Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Instagram'),
                        const SizedBox(width: 12),
                        _buildFilterChip('TikTok'),
                        const SizedBox(width: 12),
                        _buildFilterChip('YouTube'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Featured Campaigns',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Campaign List
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _filteredCampaigns.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('No campaigns found')),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildCampaignCard(_filteredCampaigns[index]),
                      );
                    }, childCount: _filteredCampaigns.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedPlatform == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlatform = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.dark : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(Campaign campaign) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(campaign: campaign),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade200, // Placeholder color
                    child: Image.network(
                      campaign.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          campaign.platform == 'Instagram'
                              ? Icons.camera_alt
                              : campaign.platform == 'TikTok'
                              ? Icons.music_note
                              : Icons.play_arrow,
                          size: 14,
                          color: AppColors.dark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          campaign.platform,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark_border, size: 20),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        campaign.brandName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.0,
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
                  const SizedBox(height: 8),
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ends in ${campaign.deadline.difference(DateTime.now()).inDays} days',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
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
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    // Nav Item implementation
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.dark : Colors.grey.shade400,
            size: 26,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.dark,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
