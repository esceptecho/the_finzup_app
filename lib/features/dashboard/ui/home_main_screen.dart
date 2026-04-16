// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/widget072.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/transactions/ui/credit_card_selection.dart';
import 'package:the_finzup_app/features/transactions/ui/transaction_screen.dart';
import 'package:the_finzup_app/features/transactions/widgets/add_card_sheet.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({super.key});

  void _showAddCardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // useSafeArea: true,
      isScrollControlled: true, // Crucial para que el modal suba con el teclado
      backgroundColor: const Color.fromARGB(
        255,
        34,
        27,
        27,
      ), // bottomsheet color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const AddCardSheet(),
      // builder: (context) => MySample(),
    );
  }

  void navigateToGrid(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Aquí pasamos los datos mock que creamos antes
        builder: (context) => TransactionGrid(transactions: mockTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ClipRRect(
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_placeholder.jpeg'),
          ),
        ),
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Aquí pasamos los datos mock que creamos antes
                  builder: (context) =>
                      // MySample(), // Credit Card example
                      Widget072(), // colored tile-grid
                ),
              );
            },
            icon: Icon(Icons.payment),
          ),
          IconButton(
            onPressed: () => _showAddCardModal(context),
            icon: Icon(Icons.payments_rounded, size: 28),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Aquí pasamos los datos mock que creamos antes
                  builder: (context) =>
                      TransactionGrid(transactions: mockTransactions),
                ),
              );
            },
            icon: Icon(Icons.monetization_on_sharp, size: 28),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/icons/buho-silueta-mini.jpg',
                ), // 'assets/images/icons/buho-silueta-mini.jpg' fondo-simple0
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(153, 0, 0, 0),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Balance Total',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '\$24,500.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 350, child: CardSelectionUI()),
        ],
      ),
    );
  }
}
