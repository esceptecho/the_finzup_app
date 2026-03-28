import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/transaction.dart';

final List<Transaction> mockTransactions = [
  Transaction(
    description: 'Sueldo Febrero',
    amount: 2500.00,
    category: Category(
      name: 'Salario', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.salary,
      iconCodePoint: Icons.payments.codePoint
    ),
    attachments: [],
    date: DateTime.now(),
  ),
  Transaction(
    description: 'Alquiler Apartamento',
    amount: 800.00,
    category: Category(
      name: 'Alquiler', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.rent,
      iconCodePoint: Icons.home.codePoint
    ),
    attachments: ['contrato.pdf'],
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transaction(
    description: 'Cena Sushi',
    amount: 45.50,
    category: Category(
      name: 'Comida', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.food,
      iconCodePoint: Icons.restaurant.codePoint
    ),
    attachments: ['ticket_sushi.jpg'],
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    description: 'Venta Laptop Usada',
    amount: 300.00,
    category: Category(
      name: 'Freelance', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.freelance,
      iconCodePoint: Icons.laptop.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    description: 'Café de especialidad',
    amount: 4.50,
    category: Category(
      name: 'Café', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.coffee,
      iconCodePoint: Icons.coffee.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    description: 'Gasolina',
    amount: 60.00,
    category: Category(
      name: 'Transporte', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.transport,
      iconCodePoint: Icons.directions_car.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Transaction(
    description: 'Consulta Médica',
    amount: 80.00,
    category: Category(
      name: 'Salud', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.health,
      iconCodePoint: Icons.local_hospital.codePoint
    ),
    attachments: ['receta.jpg'],
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    description: 'Intereses Inversión',
    amount: 12.40,
    category: Category(
      name: 'Inversiones', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.investment,
      iconCodePoint: Icons.trending_up.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Transaction(
    description: 'Compra Supermercado',
    amount: 120.00,
    category: Category(
      name: 'Comida', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.food,
      iconCodePoint: Icons.restaurant.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transaction(
    description: 'Regalo Cumpleaños',
    amount: 50.00,
    category: Category(
      name: 'Regalo', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.gift,
      iconCodePoint: Icons.card_giftcard.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Transaction(
    description: 'Sueldo Mayo',
    amount: 2800.00, // Ajustado para que tenga sentido con el nombre
    category: Category(
      name: 'Salario', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.salary,
      iconCodePoint: Icons.payments.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Transaction(
    description: 'Pago Alquiler Marzo',
    amount: 450.00,
    category: Category(
      name: 'Alquiler', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.rent,
      iconCodePoint: Icons.home.codePoint
    ),
    attachments: [],
    date: DateTime.now(),
  ),
  Transaction(
    description: 'Sueldo Quincena',
    amount: 1200.00,
    category: Category(
      name: 'Salario', 
      type: TransactionType.income, 
      subCategory: IncomeSubCategory.salary,
      iconCodePoint: Icons.payments.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transaction(
    description: 'Cena Restaurante Chino',
    amount: 35.50,
    category: Category(
      name: 'Comida', 
      type: TransactionType.expense, 
      subCategory: ExpenseSubCategory.food,
      iconCodePoint: Icons.restaurant.codePoint
    ),
    attachments: [],
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];