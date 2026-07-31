import 'package:flutter/material.dart';
import 'package:influx/theme.dart';

class GroupMember {
  final String id;
  final bool isAdmin;
  final String name;
  final double amount;
  final String? avatarImageUrl;
  final double progressValue;
  final Color backgroundColor;
  final Color valueColor;

  GroupMember({
    required this.id,
    required this.name,
    required this.amount,
    this.avatarImageUrl,
    required this.progressValue,
    this.backgroundColor = AppColors.backgroundAccent,
    this.valueColor = AppColors.white,
    required this.isAdmin,
  });

  /// Factory constructor to map database rows (`profile_group`) into `GroupMember`
  factory GroupMember.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String? ?? 'member';
    // Supabase returns joined foreign tables as a nested Map
    final profilo = json['profilo'] as Map<String, dynamic>?;

    return GroupMember(
      id: json['profile_id'] as String,
      isAdmin: role.toLowerCase() == 'admin',
      name: profilo?['full_name'] as String? ?? 'Member',
      amount: (json['paid_share'] as num?)?.toDouble() ?? 0.0,
      avatarImageUrl: profilo?['avatar_url'] as String?,
      progressValue: 0.0,
      backgroundColor: AppColors.backgroundAccent,
      valueColor: AppColors.white,
    );
  }

  /// Create a copy of this member with optional field overrides
  GroupMember copyWith({
    String? id,
    String? name,
    double? amount,
    String? avatarImageUrl,
    double? progressValue,
    Color? backgroundColor,
    Color? valueColor,
    bool? isAdmin,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
      progressValue: progressValue ?? this.progressValue,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueColor: valueColor ?? this.valueColor,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GroupMember &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              amount == other.amount &&
              avatarImageUrl == other.avatarImageUrl &&
              progressValue == other.progressValue &&
              backgroundColor == other.backgroundColor &&
              valueColor == other.valueColor &&
              isAdmin == other.isAdmin;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      avatarImageUrl.hashCode ^
      progressValue.hashCode ^
      backgroundColor.hashCode ^
      valueColor.hashCode ^
      isAdmin.hashCode;
}