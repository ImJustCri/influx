import 'base_period.dart';

class UserPeriod implements BasePeriod {
  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final DateTime endDate;
  @override
  final bool isActive;
  @override
  final double spent;
  @override
  final double budget;

  // Class-specific field
  final String profileId;

  const UserPeriod({
    required this.id,
    required this.createdAt,
    required this.endDate,
    required this.isActive,
    required this.spent,
    required this.budget,
    required this.profileId,
  });

  factory UserPeriod.fromJson(Map<String, dynamic> json) {
    return UserPeriod(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? false,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      profileId: json['profile_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'spent': spent,
      'budget': budget,
      'profile_id': profileId,
    };
  }
}