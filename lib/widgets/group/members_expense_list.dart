import 'package:flutter/material.dart';
import 'group_member_expense_tile.dart';
import '../../models/group_member.dart';

class MembersExpenseList extends StatelessWidget {
  final List<GroupMember> members;

  const MembersExpenseList({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final member = members[index];
        return GroupMemberExpenseTile(
          memberName: member.name,
          amount: member.amount,
          avatarImageUrl: member.avatarImageUrl,
          progressValue: member.progressValue,
          backgroundColor: member.backgroundColor,
          valueColor: member.valueColor,
        );
      },
    );
  }
}
