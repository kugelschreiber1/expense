import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.entertainment;

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    const deductYear = 1;
    final firstDate = DateTime(now.year - deductYear, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: const Center(child: Text("Invalid input")),
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            actions: [
              const Divider(),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"),
                ),
              ),
            ],
          );
        });
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);

    // Validate user input
    if (_titleController.text.trim().isEmpty) {
      _showErrorDialog("The expense title is required");
      return;
    }

    if (enteredAmount == null) {
      _showErrorDialog("The amount is required");
      return;
    }

    if (enteredAmount <= 0) {
      _showErrorDialog("The amount must be greater than 0");
      return;
    }

    if (_selectedDate == null) {
      _showErrorDialog("No date has been selected");
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildPotraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          maxLength: 50,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: "Title",
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),
        const SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                decoration: const InputDecoration(
                  prefixText: "Ksh ",
                  labelText: "Amount",
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? "No date selected"
                        : formatter.format(_selectedDate!),
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton(
              value: _selectedCategory,
              items: Category.values.map(
                (category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text("Add Expense"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _titleController,
                maxLength: 50,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Title",
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                decoration: const InputDecoration(
                  prefixText: "Ksh ",
                  labelText: "Amount",
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? "No date selected"
                        : formatter.format(_selectedDate!),
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text("Add Expense"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;
      Widget currentWidget =
          width < 600 ? _buildPotraitLayout() : _buildLandscapeLayout();
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10.0,
              40.0,
              10.0,
              keyboardSpace + 10.0,
            ),
            child: currentWidget,
          ),
        ),
      );
    });
  }
}
