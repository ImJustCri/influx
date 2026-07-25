import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../../models/permission_item.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/group/settings/permissions/permission_header.dart';
import '../../../widgets/group/settings/permissions/permission_row.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  static const List<PermissionItem> _permissions = [
    PermissionItem(
      title: 'Vedere le proprie spese',
      icon: LucideIcons.eye,
      iconBackgroundColor: Color(0xFF38BDF8),
      isAdminAllowed: true,
      isMemberAllowed: true,
    ),
    PermissionItem(
      title: 'Aggiungere spese',
      icon: LucideIcons.shopping_cart,
      iconBackgroundColor: Color(0xFFFF5252),
      isAdminAllowed: true,
      isMemberAllowed: true,
    ),
    PermissionItem(
      title: 'Aggiungere e modificare spese altrui',
      icon: LucideIcons.pencil,
      iconBackgroundColor: Color(0xFFEAB308),
      isAdminAllowed: true,
      isMemberAllowed: false,
    ),
    PermissionItem(
      title: 'Vedere budget totale',
      icon: LucideIcons.dollar_sign,
      iconBackgroundColor: Color(0xFF6366F1),
      isAdminAllowed: true,
      isMemberAllowed: true,
    ),
    PermissionItem(
      title: 'Modificare il budget',
      icon: LucideIcons.dollar_sign,
      iconBackgroundColor: Color(0xFF6366F1),
      isAdminAllowed: true,
      isMemberAllowed: false,
    ),
    PermissionItem(
      title: 'Gestire ruoli e permessi',
      icon: LucideIcons.users,
      iconBackgroundColor: Color(0xFFFF5252),
      isAdminAllowed: true,
      isMemberAllowed: false,
    ),
    PermissionItem(
      title: 'Vedere spese private altrui',
      icon: LucideIcons.lock,
      iconBackgroundColor: Color(0xFFA855F7),
      isAdminAllowed: true,
      isMemberAllowed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PagePadding(
        child: SafeArea(
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PermissionsHeader(),
              AppContainer(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _permissions.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFF1E293B),
                  ),
                  itemBuilder: (context, index) {
                    return PermissionRow(item: _permissions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}