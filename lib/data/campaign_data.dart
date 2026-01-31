import 'package:reachnova/models/campaign.dart';

final List<Campaign> campaignData = [
  Campaign(
    id: 'c1',
    title: 'Ethnic Wear Summer Collection',
    description:
        'Showcase our latest Kurta sets and sarees for the summer season.',
    brandName: 'FabIndia',
    budget: 25000.0,
    platform: 'Instagram',
    requirements: ['Reel', '3 Stories'],
    imageUrl:
        'https://i.pinimg.com/1200x/4c/c7/d4/4cc7d45486f4866bd49f8dfcbede3ff7.jpg',
    deadline: DateTime.now().add(const Duration(days: 10)),
    minFollowers: 10000,
  ),
  Campaign(
    id: 'c2',
    title: 'Audio Revolution Campaign',
    description:
        'Create high-energy reels featuring our latest wireless earbuds.',
    brandName: 'boAt',
    budget: 45000.0,
    platform: 'Instagram',
    requirements: ['1 Unboxing Video', '1 Main Feed Post'],
    imageUrl:
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
    deadline: DateTime.now().add(const Duration(days: 20)),
    minFollowers: 25000,
  ),
  Campaign(
    id: 'c3',
    title: 'Organic Skincare Routine',
    description:
        'Share your 5-step morning routine using our natural products.',
    brandName: 'Mamaearth',
    budget: 15000.0,
    platform: 'Instagram',
    requirements: ['Reel with Voiceover'],
    imageUrl:
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=800&q=80',
    deadline: DateTime.now().add(const Duration(days: 15)),
    minFollowers: 5000,
  ),
  Campaign(
    id: 'c4',
    title: 'Snack Healthy Campaign',
    description:
        'Promote our roasted seeds and trail mixes as the perfect desk snack.',
    brandName: 'The Whole Truth',
    budget: 8000.0,
    platform: 'Instagram',
    requirements: ['2 Stories'],
    imageUrl:
        'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=800&q=80',
    deadline: DateTime.now().add(const Duration(days: 5)),
    minFollowers: 2000,
  ),
];
