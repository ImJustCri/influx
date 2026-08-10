import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expenses/profile_group_expense_sum_profile.dart';
import 'group_member_expense_tile.dart';
import '../../models/group_member.dart';

class MembersExpenseList extends StatelessWidget {
  final List<GroupMember> members;
  final String groupId;
  final double perCapitaBudget;
  final String groupName;
  final bool isCurrentUserGroupAdmin;

  const MembersExpenseList({
    super.key,
    required this.members,
    required this.groupId,
    required this.perCapitaBudget,
    required this.groupName,
    required this.isCurrentUserGroupAdmin,
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

        return Consumer(
          builder: (context, ref, child) {
            final expenseAsync = ref.watch(
              profileGroupExpenseSumProvider((
                profileId: member.id,
                groupId: groupId,
              )),
            );

            final double? totalExpense = expenseAsync.value;

            return GroupMemberExpenseTile(
              groupId: groupId,
              memberId: member.id,
              memberName: member.name,
              amount: totalExpense ?? 0,
              avatarImageUrl: member.avatarImageUrl,
              progressValue: totalExpense != null ? totalExpense / perCapitaBudget : 0,
              backgroundColor: member.backgroundColor,
              valueColor: member.valueColor,
              groupName: groupName,
              isCurrentUserGroupAdmin: isCurrentUserGroupAdmin,
            );
          },
        );
      },
    );
  }
}