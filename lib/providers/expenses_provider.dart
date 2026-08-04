import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/expense_data.dart';


final fetchExpenses= FutureProvider<List<ExpenseData>>((ref) async {

  final user_id= await Supabase.instance.client.auth.currentUser!.id;

  final response= await  Supabase.instance.client.from('expense').select('*, category(*), group(*)').eq('profile_id',user_id);

  final result= response.map((item)=>ExpenseData.convertJson(item)).toList();

  return result;
});






