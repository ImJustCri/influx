import 'package:flutter/material.dart';
import 'package:influx/widgets/home/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';

import '../models/expense_data.dart';
import '../widgets/charts/simple_trend_chart.dart';
import '../widgets/expenses/expense_item.dart';
import '../widgets/home/budget_card.dart';
import '../widgets/home/recent_expenses_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<ExpenseData> recentExpenses = [
    ExpenseData(
      type: ExpenseType.electronics,
      title: 'Undertale',
      amount: '2,5',
    ),
    ExpenseData(
      type: ExpenseType.clothing,
      title: 'JD Sport',
      amount: '50',
    ),
    ExpenseData(
      type: ExpenseType.food,
      title: 'Carrefour',
      amount: '18,30',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height + 150,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),
              PagePadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BudgetCard(),
                    const SizedBox(height: 24),
                    SimpleTrendChart(
                      startValue: 1500,
                      endValue: 1600,
                    ),
                    const SizedBox(height: 24),
                    RecentExpensesSection(expenses: recentExpenses),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
