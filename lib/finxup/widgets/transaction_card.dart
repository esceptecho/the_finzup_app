import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.category == TransactionCategory.expense;
    final colorMonto = isExpense ? AppTheme.expenseRed : AppTheme.incomeGreen;
    final prefijoMonto = isExpense ? "-" : "+";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(transaction.icon, color: Colors.white70, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              transaction.description,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$prefijoMonto\$${transaction.monto.toStringAsFixed(2)}',
            style: TextStyle(
              color: colorMonto,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}