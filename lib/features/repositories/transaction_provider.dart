import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_finzup_app/features/models/transaction.dart';
import '../repositories/transaction_repository.dart';

// Provider para la caja de Hive (debe inicializarse en el main.dart)
final transactionBoxProvider = Provider<Box<Transaction>>((ref) {
  return Hive.box<Transaction>('transactionsBox');
});

// Provider para el Repositorio
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return HiveTransactionRepository(box);
});

// Notifier para manejar el estado de la lista de transacciones
class TransactionNotifier extends Notifier<List<Transaction>> {
  late TransactionRepository _repository;

  @override
  List<Transaction> build() {
    _repository = ref.watch(transactionRepositoryProvider);
    return _repository.getAllTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
    // Actualizamos el estado leyendo de nuevo la base de datos para mantener sincronía
    state = _repository.getAllTransactions(); 
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getAllTransactions();
  }
}

// Provider final que consumirá la UI
final transactionProvider = NotifierProvider<TransactionNotifier, List<Transaction>>(() {
  return TransactionNotifier();
});