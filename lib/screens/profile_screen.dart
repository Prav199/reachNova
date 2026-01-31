import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reachnova/providers/user_provider.dart';
import 'package:reachnova/screens/login_screen.dart';
import 'package:reachnova/screens/personal_details_screen.dart';
import 'package:reachnova/screens/policy_screen.dart';
import 'package:reachnova/screens/premium_screen.dart';
import 'package:reachnova/theme/app_colors.dart';
import 'package:reachnova/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedLanguage = 'English';

  @override
  bool get wantKeepAlive => true;

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Language',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              _buildLanguageOption('Hindi'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('French'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: _selectedLanguage == language
          ? const Icon(Icons.check, color: AppColors.dark)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.lightest,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with User Info
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(user.profileImage),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PremiumScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.stars_rounded,
                        color: AppColors.mediumDark,
                        size: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // General Section
                _buildSectionHeader('General'),
                const SizedBox(height: 12),
                _buildMenuContainer([
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.mediumDark,
                    title: 'Personal Details',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.language_rounded,
                    iconColor: AppColors.mediumDark,
                    title: 'Language',
                    trailing: _selectedLanguage,
                    onTap: _showLanguageDialog,
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.shield_outlined,
                    iconColor: AppColors.mediumDark,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PolicyScreen(
                            title: 'Privacy Policy',
                            content:
                                '...', // Omitted for brevity in this tool call
                          ),
                        ),
                      );
                    },
                  ),
                ]),

                const SizedBox(height: 24),

                // Campaign Tools Section (New)
                _buildSectionHeader('Creator Tools'),
                const SizedBox(height: 12),
                _buildMenuContainer([
                  _buildMenuItem(
                    icon: Icons.analytics_outlined,
                    iconColor: AppColors.mediumDark,
                    title: 'Analytics',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.mediumDark,
                    title: 'Earnings',
                    onTap: () {},
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 24),

                // Account Section
                _buildSectionHeader('Account'),
                const SizedBox(height: 12),
                _buildMenuContainer([
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                    title: 'Logout',
                    onTap: _showLogoutDialog,
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
          textBaseline: TextBaseline.alphabetic,
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade300,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade50,
      indent: 64,
      endIndent: 16,
    );
  }
}
