
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/models/transaction.dart';
import 'package:the_finzup_app/widgets/add_transaction_sheet.dart';

class TransactionGrid extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionGrid({super.key, required this.transactions});

  @override
  State<TransactionGrid> createState() => _TransactionGridState();
}

class _TransactionGridState extends State<TransactionGrid> {
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

  // List<String> _filterOptions () {}
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Transacciones', style: TextStyle(fontSize: 16)),
        actions: [
          // Botón de alternar visibilidad (con estilo de cápsula)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(
              onPressed: () => setState(() => isVisible = !isVisible),
              icon: Icon(
                isVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              label: Text(
                isVisible ? 'Esconder' : 'Mostrar',
                style: TextStyle(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white, // O el color de tu tema
                backgroundColor: AppColors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Botón de Agregar (más iconográfico)
          IconButton(
            onPressed: () => _openAddTransaction(context),
            icon: const Icon(Icons.add_circle_outline, size: 28),
            tooltip: 'Añadir transacción',
          ),
          const SizedBox(width: 8), // Pequeño margen al final
        ],
      ),
      body: GridView.builder(
        shrinkWrap: true,
        // change GridView and remove comments from gridDelegate
        padding: const EdgeInsets.all(16),
        // Creamos una rejilla de 2 columnas
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio:
              1.0, // Ajusta esto para que el card no se vea estirado
        ),
        itemCount: widget.transactions.length,
        itemBuilder: (context, index) {
          final tx = widget.transactions[index];
          final isExpense = tx.category.type == TransactionType.expense;
          if (isVisible) {
            return InkWell(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icono con fondo circular
                      CircleAvatar(
                        backgroundColor: (isExpense ? Colors.red.shade700 : Colors.green.shade700)
                            .withOpacity(0.1),
                        child: Icon(
                          IconData(
                            tx.category.iconCodePoint, 
                            fontFamily: 'MaterialIcons',
                          ),
                          color: isExpense ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tx.description,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greyText),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        tx.category.name,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Divider(color: AppColors.dividerColor,),
                      Text(
                        '\$${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isExpense ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: isVisible
          ? ElevatedButton(
              onPressed: () {
                // Obtenemos las coordenadas del toque
                // double x = details.globalPosition.dx;
                // double y = details.globalPosition.dy;

                showMenu(
                  context: context,
                  // Creamos un pequeño rectángulo en el punto del toque
                  position: RelativeRect.fromLTRB(0.0, 400.0, 0.0, 20.0),
                  items: [
                    const PopupMenuItem(child: ExpansionPanelListItem()),
                  ],
                );
              },
              onLongPress: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'The Finzup App',
                );
              },
              child: Icon(Icons.filter_list_rounded, size: 32, color: AppColors.iceWhite,),
            )
          : SizedBox.shrink(),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Nota ${index + 1}',
      expandedValue: 'This is item number $index',
    );
  });
}

class ExpansionPanelListItem extends StatefulWidget {
  const ExpansionPanelListItem({super.key});

  @override
  State<ExpansionPanelListItem> createState() =>
      _ExpansionPanelListItemState();
}

class _ExpansionPanelListItemState extends State<ExpansionPanelListItem> {
  final List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(child: _buildPanel()));
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(item.headerValue));
          },
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              title: Text(item.expandedValue),
              subtitle: const Text(
                'To delete this panel, tap the trash can icon',
              ),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              },
              tileColor: Colors.transparent,
              // Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
              selectedColor: AppColors.burgundyLight,
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
