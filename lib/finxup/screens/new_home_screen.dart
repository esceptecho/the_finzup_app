import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_finzup_app/features/models/assets_image_list.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/transactions/ui/transaction_screen.dart';
import 'package:the_finzup_app/finxup/models/bill.dart';
import 'package:the_finzup_app/finxup/models/database_helper.dart';
import 'package:the_finzup_app/finxup/models/goal.dart';
import 'package:the_finzup_app/finxup/models/transaction.dart';
import 'package:the_finzup_app/finxup/screens/expenses_chart_card_screen.dart';
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
import 'package:the_finzup_app/finxup/widgets/shimmer_balance_ring.dart';
import 'package:the_finzup_app/finxup/widgets/slidable_item.dart';
import 'package:the_finzup_app/finxup/widgets/transaction_card.dart';
import 'package:the_finzup_app/widgets/navigaton_drawer.dart';
import 'package:the_finzup_app/widgets/quick_note.dart';
import 'package:the_finzup_app/widgets/shimmer_border_button.dart';
import 'package:the_finzup_app/widgets/shimmer_border_wrapper.dart';
import 'package:the_finzup_app/widgets/welcome_summary_card.dart';

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
  bool _welcomeSummaryCardShown = true;
  bool isAnimating = false;
  bool showInfo = false;
  List<QuickNote> _notes = [];
  final List<String> _imagePaths = assetPathList;

  // Cargar notas de SharedPreferences
  // Cambiamos "get notes" por "loadNotes()"
  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notesJson = prefs.getString('user_notes');

      if (notesJson != null) {
        final List<dynamic> decoded = jsonDecode(notesJson);
        setState(() {
          _notes = decoded.map((item) => QuickNote.fromMap(item)).toList();
        });
      }
    } catch (e) {
      print("Error cargando notas: $e");
    }
  }

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
    _loadNotes();
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

  final image = Image.asset('assets/buho-silueta1.jpg', fit: .scaleDown);

  int _currentIndex = 0;
  bool isExpanded = false;

  String get currentNoteText {
    if (_notes.isEmpty) return "Sin notas";
    if (_currentIndex >= _notes.length) return _notes[0].text;
    return _notes[_currentIndex].text;
  }

  void _changeImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;

      // Si quieres que al cambiar se "cierre" la animación y se vuelva a abrir
      // showInfo = false;
    });
  }

  double get _imageSize =>
      showInfo ? 340.0 : 0.0; // Usamos un getter para simplificar

  void _showInformation() {
    setState(() {
      showInfo = !showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la ruta de la imagen actual basada en el índice
    // final String currentImagePath = assetPathList[_currentIndex];
    return Scaffold(
      endDrawer: NavigatonDrawer(),
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton.filled(
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
          icon: Icon(Icons.compare_arrows_rounded),
        ),
        backgroundColor: AppTheme.backgroundDeep,
        elevation: 0,
        title: TextButton(
          onPressed: () {
            _changeImage();
            _showInformation();
          },
          child: Text(
            'F I N Z U P',
            style: TextStyle(color: AppTheme.expenseRedDark),
          ),
        ),

        actions: [
          GestureDetector(
            child: Hero(
              tag: 'arees_profile',
              child: ShimmerBorderWrapper(
                isCircular: true,
                strokeWidth: 4, // Un grosor elegante para avatares
                isAnimating: true, // Siempre activo
                repeat: false, // Bucle infinito
                shimmerColor: AppTheme.expenseRedLight,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: AppTheme.expenseRedDark,
                  child: const CircleAvatar(
                    radius: 21,
                    backgroundColor: AppTheme.surface,
                    backgroundImage: AssetImage(
                      'assets/arees_profile.jpeg',
                    ), // Asegúrate de tener esta imagen en pubspec.yaml
                  ),
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
          SliverToBoxAdapter(
            child: Container(height: 12, color: AppTheme.backgroundDeep),
          ),
          // 1. Espaciado y Balance
          SliverToBoxAdapter(
            child: Stack(
              children: [
                ShimmerBorderWrapper(
                  borderRadius: 20, // Coincide con el del Container
                  strokeWidth: 2,
                  isAnimating: isAnimating,
                  repeat: false, // Bucle infinito
                  shimmerColor: AppTheme.incomeGreenDeeperDark,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppTheme.backgroundDeep,
                      // gradient: LinearGradient(...),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // if (showInfo)
                            // La imagen que crece
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                borderRadius: .circular(15),
                              ),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves
                                  .fastOutSlowIn, // Esta no genera valores negativos
                              width: double.infinity,
                              height: _imageSize,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: showInfo
                                    ? 0.3
                                    : 0.1, // Se vuelve un poco transparente al ser pequeño
                                child: Image.asset(
                                  // currentImagePath,
                                  _imagePaths[_currentIndex], // <--- Imagen dinámica
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // Texto moderno sobre la imagen (opcional)
                            // if (_imageSize >
                            //     80) // Solo mostrar si la imagen es grande
                            const SizedBox(height: 24),
                            ShimmerBalanceRing(
                              totalBalance: _calculatedBalance,
                              spentPercentage: _spentPercentage,
                            ),
                            const SizedBox(
                              height: 8,
                            ), // Espacio entre el anillo y la leyenda
                            // NUEVA LEYENDA
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const BalanceLegend(),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: ShimmerBorderButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StatisticsScreen(
                                                transactions: _transactions,
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.bar_chart_rounded,
                                      color: AppTheme.accentGoldBright,
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        // Texto de la nota sincronizado
                        if (showInfo && _notes.isNotEmpty)
                          Positioned(
                            top: 180,
                            left:
                                0, // Importante: define left y right en 0 para que ocupe todo el ancho
                            right: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 700),
                              opacity: showInfo
                                  ? 1.0
                                  : 0.0, // Solo aparece cuando la imagen crece
                              child: Container(
                                height: 160,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 32,
                                ),
                                decoration: BoxDecoration(
                                  // Un degradado se ve mucho más moderno que un bloque negro sólido
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 
                                        1.0,
                                      ), // Negro con 70% opacidad
                                    ],
                                  ),
                                ),

                                child: Text(
                                  currentNoteText, // <--- Nota dinámica
                                  // "Ubicación del Positioned: Ahora es hijo directo del Stack, lo que permite usar bottom, left, right, etc.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        24, // Un poco más grande para legibilidad
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 16,
          //     child: Divider(color: AppTheme.textDisabled.withValues(alpha: 0.4)),
          //   ),
          // ),
          // 2. Separador
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 3. Tarjeta de Resumen (Condicional)
          _welcomeSummaryCardShown
              ? SliverToBoxAdapter(
                  child: ShimmerBorderWrapper(
                    borderRadius: 20, // Coincide con el del Container
                    strokeWidth: 2,
                    isAnimating: true,
                    repeat: false, // Bucle infinito
                    shimmerColor: AppTheme.accentGoldMuted,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          WelcomeSummaryCard(
                            userName: 'Arees',
                            statusMessage:
                                'Tienes {bills.length} facturas pendientes de revisión.',
                            pendingAlerts: 3,
                            onActionTap: () {
                              setState(() {
                                _welcomeSummaryCardShown = false;
                              });
                            },
                            onTap: () {
                              setState(() {
                                _welcomeSummaryCardShown = false;
                                Navigator.pushNamed(context, '/home');
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter(child: SizedBox.shrink()),
          SliverToBoxAdapter(child: SizedBox(height: 8)),
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
                      vertical: 16,
                    ),
                    height: 180,
                    color: AppTheme.surface,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              "Tus metas aparecerán aquí. ¡Agrega tu primera meta para empezar a ahorrar!",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
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
                // _myGoals.isNotEmpty
                const SizedBox(height: 24),
                CategorySelector(
                  showTransactions: _isShowingTransactions,
                  onChanged: (val) {
                    setState(() {
                      _isShowingTransactions = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // SliverToBoxAdapter(child: SizedBox(height: 4)),
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
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          // 2. EL NUEVO GRÁFICO ELEGANTE
          SliverToBoxAdapter(child: SizedBox()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransactionModal(context),
        child: Icon(Icons.add, color: AppTheme.textWhite, size: 32),
      ),
      floatingActionButtonLocation: .centerDocked,
    );
  }

  SliverToBoxAdapter showExpensesChar() {
    return SliverToBoxAdapter(
      child: ExpensesChartCard(
        transactions:
            _transactions, // Le pasas tu lista de transacciones de la base de datos
      ),
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


// gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     Color(0xFF1A1A1A), // Base Neutral (Casi negro)
                      //     AppTheme.primaryWineDark.withValues(
                      //       alpha: 0.1,
                      //     ), // Vino suave
                      //     AppTheme.incomeGreenDark.withValues(
                      //       alpha: 0.1,
                      //     ), // Cian/Verde opaco
                      //     AppTheme.accentGoldMuted.withValues(
                      //       alpha: 0.1,
                      //     ), // Toque dorado final
                      //   ],
                      //   stops: [0.1, 0.4, 0.7, 1.0],
                      // ),