import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/models/transaction.dart';
import 'package:the_finzup_app/widgets/add_transaction_sheet.dart';
// Asegúrate de que estas rutas sean correctas en tu proyecto
// import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
// import 'package:the_finzup_app/features/models/transaction.dart';

class TransactionDraggableSheet extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionDraggableSheet({super.key, required this.transactions});

  @override
  State<TransactionDraggableSheet> createState() =>
      _TransactionDraggableSheetState();
}

class _TransactionDraggableSheetState extends State<TransactionDraggableSheet> {
  bool isVisible = true;

  void _openAddTransaction(BuildContext context) async {
    final result = await showModalBottomSheet<Transaction>(
      context: context,
      isScrollControlled: true, // Importante para que suba con el teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const AddTransactionSheet(),
    );

    if (result != null) {
      // Aquí recibes la transacción creada y la añades a tu lista
      setState(() {
        mockTransactions.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Empieza a casi mitad de pantalla
      minChildSize: 0.1, // Se puede encoger hasta ver solo el título
      maxChildSize: 0.95, // Casi pantalla completa
      snap: true, // Hace que "salte" entre estados
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor, // O AppColors.cardBgColor
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              // --- INDICADOR DE ARRASTRE (Grip) ---
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // --- CABECERA PERSONALIZADA (Reemplaza al AppBar) ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Transacciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Botón Ocultar/Mostrar mejorado
                    IconButton.filledTonal(
                      onPressed: () => setState(() => isVisible = !isVisible),
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Botón Añadir
                    IconButton.filled(
                      onPressed: () => _openAddTransaction(context),
                      icon: const Icon(Icons.add_circle_outline, size: 28),
                      tooltip: 'Añadir transacción',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // const Divider(height: 16, color: AppColors.dividerColor,),

              // --- CUERPO (GRID) ---
              Expanded(
                child: isVisible
                    ? _buildGrid(scrollController)
                    : _buildEmptyState(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid(ScrollController scrollController) {
    return GridView.builder(
      controller: scrollController, // CRÍTICO para que el sheet funcione
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0, // Un poco más alto para que quepa bien el texto
      ),
      itemCount: mockTransactions.length,
      itemBuilder: (context, index) {
        final tx = mockTransactions[index];
        final isExpense = tx.category.type == TransactionType.expense;
        final color = isExpense ? Colors.redAccent : Colors.teal;

        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      child: Icon(
                        IconData(
                          tx.category.iconCodePoint,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tx.description,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      tx.category.name,
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                      '${isExpense ? "-" : "+"}\$${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.visibility_off_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('Contenido oculto', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
