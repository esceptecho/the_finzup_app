import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BalanceRing extends StatelessWidget {
  final double totalBalance;
  final double spentPercentage;

  const BalanceRing({
    super.key,
    required this.totalBalance,
    required this.spentPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: spentPercentage, // Aquí irá tu lógica de porcentaje gastado
            strokeWidth: 28,
            backgroundColor: totalBalance == 0
                ? AppTheme.textWhite
                : totalBalance < 0 ?
                AppTheme.primaryWine.withOpacity(0.8)
                : AppTheme.incomeGreen,
            color: spentPercentage > 0.9
                ? AppTheme.expenseRed
                : totalBalance == 0.0
                ? AppTheme.textWhite
                : AppTheme.primaryWine.withOpacity(0.8),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Balance',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
