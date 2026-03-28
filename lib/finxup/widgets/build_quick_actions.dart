import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/transactions/widgets/build_action_card.dart';

class BuildQuickActions extends StatelessWidget {
const BuildQuickActions({ super.key });

  @override
  Widget build(BuildContext context){
    return buildQuickActions();
  }

  Widget buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.transparent, // Formato hexadecimal más limpio
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Acciones Rápidas', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BuildActionCard(
                      icon: Icons.arrow_upward,
                      title: 'Enviar',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.arrow_downward,
                      title: 'Recibir',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Invertir',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.payment_outlined,
                      title: 'Tarjetas',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.payments_outlined,
                      title: 'Retirar',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.public_rounded,
                      title: 'Global',
                      onTap: () {
                        print("Invertiendo");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}