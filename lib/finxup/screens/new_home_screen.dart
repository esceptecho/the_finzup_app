import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/home_pge.dart';
import 'package:the_finzup_app/finxup/models/bill.dart';
import 'package:the_finzup_app/finxup/models/database_helper.dart';
import 'package:the_finzup_app/finxup/models/goal.dart';
import 'package:the_finzup_app/finxup/models/transaction.dart';
import 'package:the_finzup_app/finxup/theme/app_theme.dart';
import 'package:the_finzup_app/finxup/widgets/add_goal_form.dart';
import 'package:the_finzup_app/finxup/widgets/add_transaction_form.dart';
import 'package:the_finzup_app/finxup/widgets/balance_legend.dart';
// import 'package:the_finzup_app/finxup/widgets/balance_ring.dart';
import 'package:the_finzup_app/finxup/widgets/bill_card.dart';
import 'package:the_finzup_app/finxup/widgets/category_selector.dart';
import 'package:the_finzup_app/finxup/widgets/expenses_chart_card.dart';
import 'package:the_finzup_app/finxup/widgets/goals_section.dart';
import 'package:the_finzup_app/finxup/widgets/new_balance_ring.dart';
import 'package:the_finzup_app/finxup/widgets/slidable_item.dart';
import 'package:the_finzup_app/finxup/widgets/transaction_card.dart';
import 'package:the_finzup_app/widgets/navigaton_drawer.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  bool _isShowingTransactions = true;
  List<Transaction> _transactions = [];
  List<Goal> _myGoals = [];
  List<Bill> _bills = [];
  bool isPaid = false;

  // 1. Obtener el total de ingresos
  double get _totalIncome {
    return _transactions
        .where((tx) => tx.category == TransactionCategory.income)
        .fold(0.0, (sum, tx) => sum + tx.monto);
  }

  // 2. Obtener el total de gastos
  double get _totalExpense {
    return _transactions
        .where((tx) => tx.category == TransactionCategory.expense)
        .fold(0.0, (sum, tx) => sum + tx.monto);
  }

  // 3. El balance sigue siendo Ingresos - Gastos
  double get _calculatedBalance => _totalIncome - _totalExpense;

  // 4. LA FÓRMULA DEL PORCENTAJE
  double get _spentPercentage {
    if (_totalIncome == 0) {
      return 0.0; // Evitar división por cero si no hay ingresos
    }

    // clamp(0.0, 1.0) asegura que el valor nunca se pase del 100% (1.0)
    // ni sea negativo, lo que rompería el CircularProgressIndicator.
    return (_totalExpense / _totalIncome).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _refreshAllData();
  }

  Future<void> _refreshAllData() async {
    final txData = await DatabaseHelper.instance.getAllTransactions();
    final billData = await DatabaseHelper.instance.getAllBills();
    final goalData = await DatabaseHelper.instance.getAllGoals();
    if (mounted) {
      setState(() {
        _transactions = txData;
        print("Lista actualizada: ${_transactions.length} items");
        _bills = billData;
        _myGoals = goalData;
      });
    }
  }

  void _markBillAsPaid(Bill bill) async {
    await DatabaseHelper.instance.deleteRow('bills', bill.id);
    await DatabaseHelper.instance.insertTransaction(
      Transaction(
        description: "Pago: ${bill.title}",
        icon: Icons.check_circle,
        category: TransactionCategory.expense,
        monto: bill.amount,
        date: bill.dueDate,
      ),
    );
    isPaid = true;
    print("Factura pagada con exito?: $isPaid ");
    _refreshAllData();
  }

  void _deleteTransaction(String id) async {
    await DatabaseHelper.instance.deleteRow('transactions', id);
    _refreshAllData();
  }

  void _deleteBill(String id) async {
    await DatabaseHelper.instance.deleteRow('bills', id);
    _refreshAllData();
  }

  // Nuevo método para abrir el modal en modo edición
  void _openEditGoalModal(Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGoalForm(
        initialGoal: goal, // Pasamos la meta existente
        onAdd: (updatedGoal) async {
          // Creamos un nuevo objeto con el mismo ID pero datos nuevos
          await DatabaseHelper.instance.updateGoal(
            Goal(
              id: goal.id, // Mantenemos el ID original
              title: updatedGoal.title,
              targetAmount: updatedGoal.targetAmount,
              currentAmount: updatedGoal.currentAmount,
              emoji: updatedGoal.emoji,
            ),
          );
          _refreshAllData();
        },
      ),
    );
  }

  void _confirmDeleteGoal(String id) {
    // Buscamos el objeto Goal completo usando el ID
    final goalToEdit = _myGoals.firstWhere((g) => g.id == id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text(
          "¿Qué deseas hacer?",
          style: TextStyle(color: Colors.white),
        ),
        content: Text("Meta: ${goalToEdit.title}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openEditGoalModal(goalToEdit);
            },
            child: const Text(
              "Editar",
              style: TextStyle(color: AppTheme.accentGoldBright),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteGoal(id);
              Navigator.pop(context);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: AppTheme.expenseRed),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(String id) async {
    await DatabaseHelper.instance.deleteRow('goals', id);
    _refreshAllData(); // Esto actualizará la lista instantáneamente
  }

  void _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
        reverseCurve: ElasticInOutCurve(),
      ),
      builder: (context) {
        return AddTransactionForm(
          isBillMode: !_isShowingTransactions,
          onAdd: (newTx) async {
            await DatabaseHelper.instance.insertTransaction(newTx);
            _refreshAllData();
          },
          onAddBill: (newBill) async {
            await DatabaseHelper.instance.insertBill(newBill);
            _refreshAllData();
          },
        );
      },
    );
  }

  void _openAddGoalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGoalForm(
        onAdd: (newGoal) async {
          await DatabaseHelper.instance.insertGoal(newGoal);
          _refreshAllData();
        },
      ),
    );
  }

  void _showAddMoneyDialog(Goal goal) {
    final TextEditingController _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          "Abonar a ${goal.title}",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Monto a ahorrar"),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final monto = double.tryParse(_amountController.text);
              if (monto != null) {
                _addMoneyToGoal(goal, monto); // <--- AQUÍ USAS TU MÉTODO
                Navigator.pop(context);
              }
            },
            child: const Text("Abonar"),
          ),
        ],
      ),
    );
  }

  // Tu método que mencionaste, ahora conectado:
  void _addMoneyToGoal(Goal goal, double amountToAdd) async {
    final updatedGoal = Goal(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount:
          goal.currentAmount + amountToAdd, // Sumamos el nuevo ahorro
      emoji: goal.emoji,
    );

    await DatabaseHelper.instance.updateGoal(updatedGoal);
    _refreshAllData(); // Refresca para ver la barra crecer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavigatonDrawer(),
      appBar: AppBar(
        leading: IconButton.filled(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePge()),
            );
          },
          icon: Icon(Icons.home_outlined),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FINXUP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            child: Hero(
              tag: 'arees_profile',
              child: CircleAvatar(
                radius: 23,
                backgroundColor: AppTheme.incomeGreenDark,
                child: const CircleAvatar(
                  radius: 21,
                  backgroundColor: AppTheme.surface,
                  backgroundImage: AssetImage(
                    'assets/arees_profile.jpeg',
                  ), // Asegúrate de tener esta imagen en pubspec.yaml
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigatonDrawer(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Espaciado y Balance
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppTheme.backgroundDeep,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     Color(0xFF1A1A1A), // Base Neutral (Casi negro)
                    //     AppTheme.primaryWineDark.withOpacity(0.1), // Vino suave
                    //     AppTheme.incomeGreenDark.withOpacity(
                    //       0.1,
                    //     ), // Cian/Verde opaco
                    //     AppTheme.accentGoldMuted.withOpacity(
                    //       0.1,
                    //     ), // Toque dorado final
                    //   ],
                    //   stops: [0.1, 0.4, 0.7, 1.0],
                    // ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      NewBalanceRing(
                        totalBalance: _calculatedBalance,
                        spentPercentage: _spentPercentage,
                      ),
                      const SizedBox(
                        height: 24,
                      ), // Espacio entre el anillo y la leyenda
                      // NUEVA LEYENDA
                      const BalanceLegend(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 24,
              color: AppTheme.backgroundDeep,
              child: Center(),
            ),
          ),
          SliverToBoxAdapter(
            child: ExpensesChartCard(
              transactions:
                  _transactions, // Le pasas tu lista de transacciones de la base de datos
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          _myGoals.isNotEmpty
              ?
                // 2. Sección de Metas (Horizontal)
                SliverToBoxAdapter(
                  child: GoalsSection(
                    goals: _myGoals,
                    onAddTap: _openAddGoalModal,
                    onDelete: (id) {
                      // Mostramos un diálogo de confirmación antes de borrar (Opcional pero recomendado)
                      _confirmDeleteGoal(id);
                    },
                    onAddMoney: (goal) => _showAddMoneyDialog(goal),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    height: 180,
                    color: AppTheme.backgroundDeep,
                    child: Center(
                      child: Column(
                        children: [
                          GoalsSection(
                            goals: _myGoals,
                            onAddTap: _openAddGoalModal,
                            onDelete: (id) {
                              // Mostramos un diálogo de confirmación antes de borrar (Opcional pero recomendado)
                              _confirmDeleteGoal(id);
                            },
                            onAddMoney: (goal) => _showAddMoneyDialog(goal),
                          ),
                          Text(
                            "Tus metas aparecerán aquí. ¡Agrega tu primera meta para empezar a ahorrar!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          // 3. Selector de Categoría
          // Lo envolvemos en un ToBoxAdapter para que scrollee con el resto
          SliverToBoxAdapter(
            child: Column(
              children: [
                _myGoals.isNotEmpty
                    ? const SizedBox(height: 60)
                    : const SizedBox(height: 12),
                CategorySelector(
                  showTransactions: _isShowingTransactions,
                  onChanged: (val) {
                    setState(() {
                      _isShowingTransactions = val;
                    });
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          // 4. La Lista de Movimientos o Facturas
          // Usamos SliverList para que sea eficiente
          _buildSliverList(),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 24,
              color: AppTheme.backgroundDeep,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(
            height: 36,
          ),),
          // 2. EL NUEVO GRÁFICO ELEGANTE
          // SliverToBoxAdapter(
          //   child: SizedBox.square(dimension: 250, child: CardSelectionUI()),
          // ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentGold,
        onPressed: () => _openAddTransactionModal(context),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: .centerDocked,
    );
  }

  Widget _buildSliverList() {
    final items = _isShowingTransactions ? _transactions : _bills;

    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          color: AppTheme.surface,
          height: 150,
          child: Center(
            child: Text(
              _isShowingTransactions
                  ? "No hay movimientos"
                  : "No hay facturas pendientes",
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (_isShowingTransactions) {
          final tx = _transactions[index];
          return SlidableItem(
            onDelete: () => _deleteTransaction(tx.id!),
            child: TransactionCard(transaction: tx),
          );
        } else {
          final bill = _bills[index];
          return SlidableItem(
            onDelete: () => _deleteBill(bill.id),
            onToggleStatus: () => _markBillAsPaid(bill),
            child: BillCard(bill: bill, isPaid: isPaid),
          );
        }
      }, childCount: items.length),
    );
  }
}





  
  // Previo body
  // Column(
  //   children: [
  //     const SizedBox(height: 24),
  //     BalanceRing(
  //       totalBalance: _calculatedBalance,
  //       spentPercentage: _spentPercentage,
  //     ),
  //     const SizedBox(height: 40),
  //     // Nueva sección de metas
  //     GoalsSection(goals: _myGoals, onAddTap: _openAddGoalModal),

  //     const SizedBox(height: 24),
  //     CategorySelector(
  //       showTransactions: _isShowingTransactions,
  //       onChanged: (val) {
  //         setState(() {
  //           _isShowingTransactions = val;
  //         });
  //       },
  //     ),

  //     // Lógica simplificada y corregida del Expanded
  //     Expanded(child: _buildList()),
  //     const SizedBox(height: 24),
  //   ],
  // ),

  // Separar el ListView en un método ayuda a mantener el build limpio
  // Widget _buildList() {
  //   if (_isShowingTransactions) {
  //     if (_transactions.isEmpty) {
  //       return Center(
  //         child: Text(
  //           "No hay facturas pendientes",
  //           style: TextStyle(color: Colors.white54),
  //         ),
  //       );
  //     }

  //     return ListView.builder(
  //       itemCount: _transactions.length,
  //       itemBuilder: (context, index) {
  //         final tx = _transactions[index];
  //         return SlidableItem(
  //           onDelete: () {
  //             print("Intentando borrar ID: ${tx.id}");
  //             _deleteTransaction(tx.id!);
  //           },
  //           child: TransactionCard(transaction: tx),
  //         );
  //       },
  //     );
  //   } else {
  //     if (_bills.isEmpty) {
  //       return Center(
  //         // child: Text(
  //         //   "No hay facturas pendientes",
  //         //   style: TextStyle(color: Colors.white54),
  //         // ),
  //         child: SizedBox(
  //           width: double.infinity, // Define un ancho fijo
  //           height: 300, // Define un alto fijo
  //           child: Lottie.asset(
  //             "assets/lotties/Fireworks.json",
  //             fit: BoxFit.contain,
  //             repeat: true,
  //           ),
  //         ),
  //       );
  //     }

  //     return ListView.builder(
  //       itemCount: _bills.length,
  //       itemBuilder: (context, index) {
  //         final bill = _bills[index];
  //         return SlidableItem(
  //           onDelete: () => _deleteBill(bill.id),
  //           onToggleStatus: () => _markBillAsPaid(bill),
  //           child: BillCard(bill: bill),
  //         );
  //       },
  //     );
  //   }
  

