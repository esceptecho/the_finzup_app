import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import 'package:the_finzup_app/finxup/models/bill.dart';
import 'package:the_finzup_app/finxup/models/goal.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finzup.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Subimos la versión a 2 si ya tenías la base de datos creada anteriormente
    // para que dispare el proceso de actualización si fuera necesario, 
    // o simplemente borra la app del cel y vuelve a instalar.
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // TODAS las tablas deben crearse aquí, una sola vez.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        description TEXT,
        icon INTEGER,
        category TEXT,
        monto REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE bills (
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        dueDate TEXT,
        isPaid INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE goals (
        id TEXT PRIMARY KEY,
        title TEXT,
        targetAmount REAL,
        currentAmount REAL,
        emoji TEXT
      )
    ''');
  }

  // --- TRANSACCIONES ---
  Future<void> insertTransaction(Transaction tx) async {
    final db = await instance.database;
    await db.insert('transactions', {
      'id': tx.id,
      'description': tx.description,
      'icon': tx.icon.codePoint,
      'category': tx.category.name,
      'monto': tx.monto,
    });
    // ELIMINADO: El bloque CREATE TABLE goals que tenías aquí
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'id DESC');

    return result.map((json) => Transaction.fromDb(
      id: json['id'] as String,
      description: json['description'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      category: TransactionCategory.values.byName(json['category'] as String),
      monto: json['monto'] as double,
      date: DateTime.now(),
      
    )).toList();
  }

  // --- BILLS ---
  Future<void> insertBill(Bill bill) async {
    final db = await instance.database;
    await db.insert('bills', {
      'id': bill.id,
      'title': bill.title,
      'amount': bill.amount,
      'dueDate': bill.dueDate.toIso8601String(),
      'isPaid': bill.isPaid
      // 'isPaid': bill.isPaid ? 1 : 0, // Importante si agregas switch de pagado
    });
  }

  Future<List<Bill>> getAllBills() async {
    final db = await instance.database;
    final result = await db.query('bills', orderBy: 'dueDate ASC');
    return result.map((json) => Bill(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as double,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isPaid: json['isPaid'] == 1,
    )).toList();
  }

  // --- GOALS ---
  Future<void> insertGoal(Goal goal) async {
    final db = await instance.database;
    await db.insert('goals', {
      'id': goal.id,
      'title': goal.title,
      'targetAmount': goal.targetAmount,
      'currentAmount': goal.currentAmount,
      'emoji': goal.emoji,
    });
  }

  Future<List<Goal>> getAllGoals() async {
    final db = await instance.database;
    final result = await db.query('goals');
    return result.map((json) => Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: json['targetAmount'] as double,
      currentAmount: json['currentAmount'] as double,
      emoji: json['emoji'] as String,
    )).toList();
  }

  Future<void> updateGoalAmount(String id, double newAmount) async {
    final db = await instance.database;
    await db.update('goals', {'currentAmount': newAmount}, where: 'id = ?', whereArgs: [id]);
  }

  // --- GENÉRICO ---
  Future<int> deleteRow(String table, String id) async {
    final db = await instance.database;
    final result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    debugPrint('Filas borradas en $table: $result');
    return result;
  }

  // --- ACTUALIZAR TRANSACCIÓN ---
Future<int> updateTransaction(Transaction tx) async {
  final db = await instance.database;
  return await db.update(
    'transactions',
    {
      'description': tx.description,
      'category': tx.category.name,
      'monto': tx.monto,
      'icon': tx.icon.codePoint,
      'date': tx.date.toIso8601String(), // Guardamos la nueva fecha
    },
    where: 'id = ?',
    whereArgs: [tx.id],
  );
}

// --- ACTUALIZAR FACTURA (BILL) ---
Future<int> updateBill(Bill bill) async {
  final db = await instance.database;
  return await db.update(
    'bills',
    {
      'title': bill.title,
      'amount': bill.amount,
      'dueDate': bill.dueDate.toIso8601String(),
      'isPaid': bill.isPaid, // Importante si agregas switch de pagado
      // 'isPaid': bill.isPaid ? 1 : 0, // Importante si agregas switch de pagado
    },
    where: 'id = ?',
    whereArgs: [bill.id],
  );
}

// --- ACTUALIZAR META (GOAL) ---
Future<int> updateGoal(Goal goal) async {
  final db = await instance.database;
  return await db.update(
    'goals',
    {
      'title': goal.title,
      'targetAmount': goal.targetAmount,
      'currentAmount': goal.currentAmount,
      'emoji': goal.emoji,
    },
    where: 'id = ?',
    whereArgs: [goal.id],
  );
}
}