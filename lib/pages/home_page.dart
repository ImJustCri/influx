import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/providers/expenses_provider.dart';
import 'package:influx/services/ocr_service.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/home/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';
import '../widgets/home/budget_card.dart';
import '../widgets/home/recent_expenses_section.dart';
import 'expenses/add_expense_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  ConsumerState<HomePage> createState()=> HomePageState();
}

  class HomePageState extends ConsumerState<HomePage>{


  @override
  Widget build(BuildContext context) {
    final OcrService s=OcrService();

    final expensesAsync = ref.watch(fetchExpenses);

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
                    BudgetCard(
                      totalExpenses: 500,
                      resetDate: DateTime(2026, 6, 1),
                    ),
                    const SizedBox(height: 24),

                    expensesAsync.when(
                        loading: ()=> const CircularProgressIndicator(),

                        data: (expense){
                          return RecentExpensesSection(expenses: expense);
                        },
                        error: (error, stack)=> Text(error.toString()),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 136),
        child: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AddExpensePage()
                ),

              );
              ref.invalidate(fetchExpenses);

            },
          backgroundColor: AppColors.backgroundAccent,
          icon: Icon(LucideIcons.circle_plus, color: AppColors.purple),
          label: Text("Aggiungi", style: TextStyle(color: AppColors.white))
        ),
      ),
    );

  }
}
