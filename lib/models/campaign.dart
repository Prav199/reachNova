class Campaign {
  final String id;
  final String title;
  final String description;
  final String brandName;
  final double budget;
  final String platform;
  final List<String> requirements;
  final String imageUrl;
  final DateTime deadline;
  final int minFollowers;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.brandName,
    required this.budget,
    required this.platform,
    required this.requirements,
    required this.imageUrl,
    required this.deadline,
    this.minFollowers = 0,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      brandName: json['brandName'] as String,
      budget: (json['budget'] as num).toDouble(),
      platform: json['platform'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      imageUrl: json['imageUrl'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      minFollowers: json['minFollowers'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'brandName': brandName,
      'budget': budget,
      'platform': platform,
      'requirements': requirements,
      'imageUrl': imageUrl,
      'deadline': deadline.toIso8601String(),
      'minFollowers': minFollowers,
    };
  }
}
