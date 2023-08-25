import 'package:flutter/cupertino.dart';
import 'package:expense/models/expense_model.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Text(
          expenses[index].id,
        );
      },
    );
  }
}
