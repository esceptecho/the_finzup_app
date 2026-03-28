import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.category.type == TransactionType.expense;
    final color = isExpense ? Colors.redAccent : Colors.green;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(
                    IconData(transaction.category.iconCodePoint, fontFamily: 'MaterialIcons'),
                    color: color,
                  ),
                ),
                if (transaction.attachments.isNotEmpty)
                  const Icon(Icons.attach_file, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              transaction.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Spacer(),
            Text(
              transaction.category.name,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              '${isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}