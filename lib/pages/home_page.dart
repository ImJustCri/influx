import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/services/ocr_service.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/home/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_data.dart';
import '../widgets/expenses/expense_type_helpers.dart';
import '../widgets/home/budget_card.dart';
import '../widgets/home/recent_expenses_section.dart';
import 'expenses/add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState()=> HomePageState();
  }

  class HomePageState extends State<HomePage>{

  List<ExpenseData> recentExpenses = [];

  @override
  void initState(){
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async{
    final result= await Supabase.instance.client.from('expense').select();

    print("spese: $result");

    setState(() {
      recentExpenses= result.map((item)=>ExpenseData.convertJson(item)).toList();
    });

  }

  @override
  Widget build(BuildContext context) {
    final OcrService s=OcrService();

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
                    RecentExpensesSection(expenses: recentExpenses),
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
              // final a = await s.ocrMethod();
              // showDialog(
              //     context: context,
              //     builder: (builder){
              //       return AlertDialog(
              //         title: Text("Ocr"),
              //         content: Text(a ?? "ciao"),
              //         actions: [
              //           ElevatedButton(
              //               onPressed: (){
              //                 Navigator.pop(context);
              //               }, child: Text("chiudi"),
              //           )
              //         ],
              //       );
              //     }
              // );
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AddExpensePage()
                ),
              );

            },
          backgroundColor: AppColors.backgroundAccent,
          icon: Icon(LucideIcons.circle_plus, color: AppColors.purple),
          label: Text("Aggiungi", style: TextStyle(color: AppColors.white))
        ),
      ),
    );

  }
}
