import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

enum TransactionCategory { income, expense }

class Transaction {
  String? id;
  final String description;
  final IconData icon;
  final TransactionCategory category;
  final double monto;
  final DateTime date;

  Transaction({
    required this.description,
    required this.icon,
    required this.category,
    required this.monto,
    required this.date,
  }) : id = uuid.v4();

  Transaction.fromDb({
    required this.id,
    required this.description,
    required this.icon,
    required this.category,
    required this.monto,
    required this.date,
  });
}
