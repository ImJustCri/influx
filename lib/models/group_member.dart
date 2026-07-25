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

  /// Create a copy of this member with optional field overrides
  GroupMember copyWith({
    String? id,
    String? name,
    double? amount,
    String? avatarImageUrl,
    double? progressValue,
    Color? backgroundColor,
    Color? valueColor,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
      progressValue: progressValue ?? this.progressValue,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueColor: valueColor ?? this.valueColor,
      isAdmin: isAdmin ?? false,
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
              valueColor == other.valueColor;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      avatarImageUrl.hashCode ^
      progressValue.hashCode ^
      backgroundColor.hashCode ^
      valueColor.hashCode;
}
