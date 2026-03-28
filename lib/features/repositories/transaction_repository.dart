import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_finzup_app/features/models/transaction.dart';

// Interfaz del repositorio
abstract class TransactionRepository {
  List<Transaction> getAllTransactions();
  Future<void> addTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

// Implementación con Hive
class HiveTransactionRepository implements TransactionRepository {
  final Box<Transaction> _box;

  HiveTransactionRepository(this._box);

  @override
  List<Transaction> getAllTransactions() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }
}