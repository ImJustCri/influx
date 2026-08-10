import 'base_period.dart';

class GroupPeriod implements BasePeriod {
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

  // Class-specific fields
  final double perCapitaBudget;
  final String groupId;

  const GroupPeriod({
    required this.id,
    required this.createdAt,
    required this.endDate,
    required this.isActive,
    required this.spent,
    required this.budget,
    required this.perCapitaBudget,
    required this.groupId,
  });

  factory GroupPeriod.fromJson(Map<String, dynamic> json) {
    return GroupPeriod(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? false,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      perCapitaBudget: (json['perCapitaBudget'] as num?)?.toDouble() ?? 0.0,
      groupId: json['group_id'] as String,
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
      'perCapitaBudget': perCapitaBudget,
      'group_id': groupId,
    };
  }
}