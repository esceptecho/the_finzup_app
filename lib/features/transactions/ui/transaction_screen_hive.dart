import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/transaction.dart';
import 'package:the_finzup_app/widgets/transaction_card.dart';

class TransactionScreen extends StatelessWidget {
  final List<Transaction> transactions;

   const TransactionScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado de las transacciones

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Transacciones'),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('No hay transacciones aún. ¡Agrega una!'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85, // Ajusta la proporción ancho/alto del Card
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionCard(transaction: transaction);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí iría la navegación al formulario para agregar transacciones
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/transaction_provider.dart';
// import '../models/transaction.dart';

// class TransactionGridScreen extends ConsumerWidget {
//   const TransactionGridScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final transactions = ref.watch(transactionProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('FinzUp - Mis Finanzas')),
//       body: transactions.isEmpty
//           ? const Center(child: Text('No hay transacciones guardadas'))
//           : GridView.builder(
//               padding: const EdgeInsets.all(15),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // Dos columnas
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 15,
//                 childAspectRatio: 0.9,
//               ),
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final tx = transactions[index];
//                 return TransactionCard(transaction: tx);
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddTransactionModal(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class TransactionCard extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionCard({super.key, required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     final isExpense = transaction.category.type == TransactionType.expense;
    
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: (isExpense ? Colors.red : Colors.green).withOpacity(0.1),
//               child: Icon(
//                 IconData(transaction.category.iconCodePoint, fontFamily: 'MaterialIcons'),
//                 color: isExpense ? Colors.red : Colors.green,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               transaction.description,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               transaction.category.name,
//               style: TextStyle(color: Colors.grey[600], fontSize: 12),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${isExpense ? "-" : "+"}\$${transaction.amount.toStringAsFixed(2)}',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w900,
//                 color: isExpense ? Colors.red : Colors.green,
//               ),
//             ),
//             if (transaction.attachments.isNotEmpty)
//               const Padding(
//                 padding: EdgeInsets.only(top: 8.0),
//                 child: Icon(Icons.attach_file, size: 14, color: Colors.blueGrey),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }