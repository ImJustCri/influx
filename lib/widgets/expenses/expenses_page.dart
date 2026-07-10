import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';
import '../round_linear_progress_bar.dart';
import 'expense_category_bar.dart';
import 'expense_type_helpers.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text('Le mie spese', style: AppTypography.pageTitle),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: [
          TextButton.icon(
            onPressed: () {},
            label: Text('Maggio', style: AppTypography.pageSubtitle),
            icon: const Icon(LucideIcons.chevron_down),
          )
        ],
      ),
      body: PagePadding(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Per categoria", style: AppTypography.containerBody),
            ...ExpenseType.values.map(
                  (type) => ExpenseCategoryBar(
                type: type,
                amount: amountFor(type),
                percentage: percentageFor(type),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
