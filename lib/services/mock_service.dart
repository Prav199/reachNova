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
    name: 'Jemision',
    email: 'jemision@example.com',
    profileImage: 'assets/images/profile_placeholder.png',
    role: UserRole.influencer,
    bio: 'Lifestyle & Tech Content Creator',
    socialFollowing: {
      'Instagram': 12000,
      'YouTube': 50000,
      'TikTok': 500, // Low count to test ineligibility
    },
  );

  // Mock Campaigns
  // Mock Campaigns
  final List<Campaign> _campaigns = campaignData;

  final List<Application> _applications = [];

  // Simulate API Delay
  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // API Methods
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
          'Your application for "Summer Fashion Drop" has been accepted. Check your dashboard.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'New Campaign Alert',
      message: 'Sony has posted a new campaign matching your profile.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Profile View',
      message: 'Your profile was viewed by Adidas Marketing Team.',
      date: DateTime.now().subtract(const Duration(days: 2)),
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
