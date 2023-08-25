import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  rent,
  transport,
  travel,
  food,
  utilities,
  education,
  personal,
  health,
  work,
  entertainment,
}

const categoryIcons = {
  Category.rent: Icons.home,
  Category.transport: Icons.directions_car,
  Category.travel: Icons.flight,
  Category.food: Icons.fastfood,
  Category.utilities: Icons.lightbulb,
  Category.education: Icons.school,
  Category.personal: Icons.person,
  Category.health: Icons.local_hospital,
  Category.work: Icons.work,
  Category.entertainment: Icons.movie,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
