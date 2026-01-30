import 'package:reachnova/models/campaign.dart';

final List<Campaign> campaignData = [
  Campaign(
    id: 'c1',
    title: 'Summer Fashion Drop',
    description: 'Promote our new summer collection with creative reels.',
    brandName: 'Zara',
    budget: 1500.0,
    platform: 'Instagram',
    requirements: ['Reel', 'Story'],
    imageUrl: 'assets/images/fashion_campaign.png',
    deadline: DateTime.now().add(const Duration(days: 14)),
    minFollowers: 5000,
  ),
  Campaign(
    id: 'c2',
    title: 'Tech Review Series',
    description: 'Detailed review of the new noise-cancelling headphones.',
    brandName: 'Sony',
    budget: 2500.0,
    platform: 'YouTube',
    requirements: ['Video Review', 'Social Share'],
    imageUrl: 'assets/images/tech_campaign.png',
    deadline: DateTime.now().add(const Duration(days: 30)),
    minFollowers: 10000,
  ),
  Campaign(
    id: 'c3',
    title: 'Eco-Friendly Skincare',
    description: 'Showcase our organic skincare routine.',
    brandName: 'Kiehl\'s',
    budget: 800.0,
    platform: 'TikTok',
    requirements: ['Short Video', 'Before/After'],
    imageUrl: 'assets/images/skincare_campaign.png',
    deadline: DateTime.now().add(const Duration(days: 7)),
    minFollowers: 10000, // User has only 500, should be ineligible
  ),
];
