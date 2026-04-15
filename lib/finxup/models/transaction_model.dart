import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

// Enums simplificados y directos
enum TransactionType { income, expense }

enum IncomeSubCategory {
  salary, tips, investment, bonus, gift, rental, 
  sales, dividend, interest, refund, pension, freelance, rewards, others
}

enum ExpenseSubCategory {
  food, rent, transport, health, education, leisure,
  shopping, services, taxes, insurance, gym, gifts,
  coffee, impulsive, snacks, online, subscription, delivery,
  entertainment, interest, savings, offerings, clothing, others
}

class Transaction {
  final String id;
  final String description;
  final double amount; // Reemplaza a 'monto'
  final TransactionType type; // Reemplaza a TransactionCategory
  final Enum? subCategory; // Opcional para soportar flujos simples y complejos
  final IconData icon;
  final List<String> attachments;
  final DateTime date;

  Transaction({
    String? id, // Si es nulo, se genera uno nuevo
    required this.description,
    required this.amount,
    required this.type,
    this.subCategory,
    required this.icon,
    this.attachments = const [], // Lista vacía por defecto
    required this.date,
  }) : id = id ?? uuid.v4();

  // copyWith para actualizar el estado (Riverpod/Provider)
  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    TransactionType? type,
    Enum? subCategory,
    IconData? icon,
    List<String>? attachments,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      subCategory: subCategory ?? this.subCategory,
      icon: icon ?? this.icon,
      attachments: attachments ?? this.attachments,
      date: date ?? this.date,
    );
  }

  // Perfecto para DataHelper (SQLite o SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.name, // Guarda 'income' o 'expense'
      'subCategory': subCategory?.name, // Guarda 'salary', 'food', etc. (o null)
      'iconCodePoint': icon.codePoint,
      'attachments': jsonEncode(attachments), // Ideal para SQLite
      'date': date.toIso8601String(),
    };
  }

  // Constructor para leer desde DataHelper
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      type: TransactionType.values.firstWhere((e) => e.name == map['type']),
      subCategory: _parseSubCategory(map['type'], map['subCategory']),
      icon: IconData(map['iconCodePoint'], fontFamily: 'MaterialIcons'),
      attachments: List<String>.from(jsonDecode(map['attachments'] ?? '[]')),
      date: DateTime.parse(map['date']),
    );
  }

  // Parseo seguro de subcategorías al leer de la BD
  static Enum? _parseSubCategory(String typeStr, String? subCatStr) {
    if (subCatStr == null || subCatStr.isEmpty) return null;

    if (typeStr == TransactionType.income.name) {
      return IncomeSubCategory.values.firstWhere(
        (e) => e.name == subCatStr,
        orElse: () => IncomeSubCategory.others,
      );
    } else if (typeStr == TransactionType.expense.name) {
      return ExpenseSubCategory.values.firstWhere(
        (e) => e.name == subCatStr,
        orElse: () => ExpenseSubCategory.others,
      );
    }
    return null;
  }
}