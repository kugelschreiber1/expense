import 'package:flutter/material.dart';
import 'package:expense/widgets/expenses_list.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/widgets/new_expense.dart';
import 'package:expense/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Netflix",
      amount: 850,
      date: DateTime.now(),
      category: Category.entertainment,
    ),
    Expense(
      title: "Work Desk",
      amount: 2500,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "48 Laws of Power",
      amount: 700,
      date: DateTime.now(),
      category: Category.education,
    ),
    Expense(
      title: "Gas August",
      amount: 1000,
      date: DateTime.now(),
      category: Category.utilities,
    ),
    Expense(
      title: "Food",
      amount: 3000,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "Rent",
      amount: 10000,
      date: DateTime.now(),
      category: Category.rent,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted!"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text(
        "Add some expenses to track",
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expenses Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
