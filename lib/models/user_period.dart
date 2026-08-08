class UserPeriod {
  final int id;
  final DateTime createdAt;
  final DateTime endDate;
  final bool isActive;
  final String profileId;
  final double spent;
  final double budget;

  UserPeriod({required this.id, required this.createdAt, required this.endDate, required this.isActive, required this.spent, required this.budget, required this.profileId});

  factory UserPeriod.fromJson(Map<String, dynamic> json) {
    return UserPeriod(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'] as bool,
      profileId: json['profile_id'] as String,
      spent: (json['spent'] as num).toDouble(),
      budget: (json['budget'] as num).toDouble(),

    );
  }
}