import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../global.dart';
import '../../models/expense_data.dart';
import '../../theme.dart';
import '../../widgets/charts/simple_trend_chart.dart';
import '../../widgets/expenses/expense_category_bar.dart';
import '../../widgets/expenses/expense_type_helpers.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  static final List<ExpenseData> _mockExpenses = [
    ExpenseData(type: ExpenseType.food, title: 'Spesa', amount: '50', purchaseDate: DateTime.now()),
    ExpenseData(type: ExpenseType.food, title: 'Ristorante', amount: '25.00', purchaseDate: DateTime.now()),
    ExpenseData(type: ExpenseType.fuel, title: 'Benzina', amount: '50.00', purchaseDate: DateTime.now()),
    ExpenseData(type: ExpenseType.onlineServices, title: 'Cinema', amount: '12.00', purchaseDate: DateTime.now()),
    ExpenseData(type: ExpenseType.pharmacy, title: 'Bolletta Luce', amount: '85.20', purchaseDate: DateTime.now()),
    ExpenseData(type: ExpenseType.electronics, title: 'Google Pixel 10a', amount: '500', purchaseDate: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    final double totalSpent = _mockExpenses.fold(0.0, (sum, item) => sum + item.numericAmount);

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
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 48,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   width: double.infinity,
              //   child: TextButton.icon(
              //     onPressed: () {},
              //     label: Text('Maggio', style: AppTypography.pageSubtitle),
              //     icon: const Icon(LucideIcons.chevron_down),
              //     iconAlignment: IconAlignment.end,
              //   ),
              // ),
          
              // Text("Per categoria", style: AppTypography.containerBody),
              SimpleTrendChart(
                firstValue: 200,
                secondValue: 350,
                thirdValue: spent,
              ),
          
              Column(
                spacing: 16,
                children: [
                  ...ExpenseType.values.map(
                        (type) {
                      final double categorySpent = _mockExpenses
                          .where((item) => item.type == type)
                          .fold(0.0, (sum, item) => sum + item.numericAmount);
          
                      return ExpenseCategoryBar(
                          type: type,
                          amount: amountFor(type, categorySpent),
                          percentage: percentageFor(type, totalSpent, categorySpent)
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}