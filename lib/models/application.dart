enum ApplicationStatus { pending, accepted, rejected }

class Application {
  final String id;
  final String campaignId;
  final String userId;
  final ApplicationStatus status;
  final DateTime appliedDate;

  Application({
    required this.id,
    required this.campaignId,
    required this.userId,
    required this.status,
    required this.appliedDate,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as String,
      campaignId: json['campaignId'] as String,
      userId: json['userId'] as String,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.${json['status']}',
        orElse: () => ApplicationStatus.pending,
      ),
      appliedDate: DateTime.parse(json['appliedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'userId': userId,
      'status': status.toString().split('.').last,
      'appliedDate': appliedDate.toIso8601String(),
    };
  }
}
