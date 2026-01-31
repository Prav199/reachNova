import 'package:reachnova/models/campaign.dart';
import 'package:reachnova/models/user.dart';
import 'package:reachnova/models/application.dart';
import 'package:reachnova/models/notification_item.dart';
import 'package:reachnova/data/campaign_data.dart';

class MockService {
  static final MockService _instance = MockService._internal();

  factory MockService() {
    return _instance;
  }

  MockService._internal();

  // Mock User
  User _currentUser = User(
    id: 'u1',
    name: 'Arjun Kapoor',
    email: 'arjun.kapoor@example.in',
    phone: '+91 98765 43210',
    profileImage: 'assets/images/avatar.png',
    role: UserRole.influencer,
    bio:
        'Tech & Lifestyle Enthusiast from Mumbai. Loving the Creator Economy! 🇮🇳',
    socialFollowing: {'Instagram': 25000, 'YouTube': 15000, 'TikTok': 0},
    socialHandles: {
      'Instagram': '@arjun_creates',
      'YouTube': 'ArjunKapoorOfficial',
      'Twitter': '@arjun_k',
    },
  );

  final List<Campaign> _campaigns = campaignData;
  final List<Application> _applications = [];

  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<User> getUser(String id) async {
    await _delay();
    return _currentUser;
  }

  Future<User> getCurrentUser() async {
    await _delay();
    return _currentUser;
  }

  Future<List<Campaign>> getCampaigns() async {
    await _delay();
    return _campaigns;
  }

  Future<Campaign> getCampaignById(String id) async {
    await _delay();
    return _campaigns.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Campaign not found'),
    );
  }

  Future<void> submitApplication(Application application) async {
    await _delay();
    _applications.add(application);
  }

  Future<List<Application>> getUserApplications(String userId) async {
    await _delay();
    return _applications.where((a) => a.userId == userId).toList();
  }

  // Mock Notifications
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Application Accepted!',
      message:
          'Your application for "boAt Audio Revolution" has been accepted. Check your dashboard.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'New Campaign Alert',
      message: 'FabIndia has posted a new campaign matching your profile.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  Future<List<NotificationItem>> getNotifications() async {
    await _delay();
    return _notifications;
  }

  Future<User> updateUser(User user) async {
    await _delay();
    _currentUser = user;
    return _currentUser;
  }
}
