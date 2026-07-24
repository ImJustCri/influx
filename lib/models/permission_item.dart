import 'package:flutter/material.dart';

class PermissionItem {
  final String title;
  final IconData icon;
  final Color iconBackgroundColor;
  final bool isAdminAllowed;
  final bool isMemberAllowed;

  const PermissionItem({
    required this.title,
    required this.icon,
    required this.iconBackgroundColor,
    required this.isAdminAllowed,
    required this.isMemberAllowed,
  });
}