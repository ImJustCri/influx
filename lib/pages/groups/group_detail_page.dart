import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/models/group.dart';
import 'package:influx/pages/groups/settings/group_admin_settings.dart';
import 'package:influx/widgets/home/budget_card.dart';
import 'package:influx/widgets/page_padding.dart';

import '../../theme.dart';
import '../../widgets/group/members_expense_list.dart';
import '../../models/group_member.dart';

class GroupDetailPage extends StatefulWidget {
  final Group group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late final List<GroupMember> members;

  @override
  void initState() {
    super.initState();
    members = [
      GroupMember(
        id: '1',
        name: 'Mario Rossi',
        amount: 1280,
        avatarImageUrl: 'https://cdn.pfps.gg/pfps/8324-mario-profile-image.png',
        progressValue: 0.5,
        isAdmin: true,
      ),
      GroupMember(
        id: '2',
        name: 'Luigi Rossi',
        amount: 950,
        avatarImageUrl: 'https://cdn.pfps.gg/pfps/7553-paper-luigi.png',
        progressValue: 0.35,
        isAdmin: false,
      ),
      GroupMember(
        id: '3',
        name: 'Peach Rossi',
        amount: 2100,
        avatarImageUrl: 'https://example.com/peach.png',
        progressValue: 0.75,
        isAdmin: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.group.name, style: AppTypography.pageTitle),
                      Text('Budget condiviso', style: AppTypography.pageSubtitle),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupAdminSettings(members: members),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.settings_2),
                  )
                ],
              ),
            ),
            PagePadding(
              child: Column(
                spacing: 24,
                children: [
                  BudgetCard(
                    totalBudget: widget.group.totalBudget,
                    totalExpenses: 10,
                    resetDate: widget.group.startedAt ?? DateTime.now(),
                    isNotAuthorized: true,
                    isGroup: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text('Spese per membro', style: AppTypography.containerBody),
                      MembersExpenseList(members: members),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}