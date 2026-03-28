import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid(); 

enum TransactionType {
  income(IncomeSubCategory.values),
  expense(ExpenseSubCategory.values);

  final List<Enum> subCategories;
  const TransactionType(this.subCategories);
}

enum IncomeSubCategory {
  salary, tips, investment, bonus, gift, rental, 
  sales, dividend, interest, refund, pension, freelance, rewards, others;
  
  String get name => toString().split('.').last;
}

enum ExpenseSubCategory {
  food, rent, transport, health, education, leisure,
  shopping, services, taxes, insurance, gym, gifts,
  coffee, impulsive, snacks, online, subscription, delivery,
  entertaiment, interest, savings, offerings, clothing, others;

  String get name => toString().split('.').last;
}


class Category {
  final String name;
  final TransactionType type;
  final Enum subCategory; // El sub-enum específico
  final int iconCodePoint;

  Category({
    required this.name,
    required this.type,
    required this.subCategory,
    required this.iconCodePoint,
  });
}

class Transaction {
  final String id;
  final String description;
  final double amount;
  final Category category;
  final IconData icon;
  final List<String> attachments;
  final DateTime date;

  Transaction({
    required this.description,
    required this.amount,
    required this.category,
    required this.icon,
    required this.attachments,
    required this.date,
  }) : id = uuid.v4();

  // Útil para actualizar el estado en Riverpod
  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    Category? category,
    List<String>? attachments,
    DateTime? date,
  }) {
    return Transaction(
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      icon: icon, // El icono no cambia, se deriva de la categoría
      attachments: attachments ?? this.attachments,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': {
        'name': category.name,
        'type': category.type.toString(),
        'subCategory': category.subCategory.toString(),
        'iconCodePoint': category.iconCodePoint,
      },
      'attachments': attachments,
      'date': date.toIso8601String(),
    };
  }
}