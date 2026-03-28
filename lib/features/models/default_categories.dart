import 'package:flutter/material.dart';
import 'transaction.dart'; // Ajusta la ruta a tu modelo

class DefaultCategories {
  // --- GASTOS ---
  static final List<Category> expenses = [
    Category(
      name: 'Comida/Restaurante',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.food,
      iconCodePoint: Icons.restaurant.codePoint, 
    ),
    Category(
      name: 'Café',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.coffee,
      iconCodePoint: Icons.coffee.codePoint,
    ),
    Category(
      name: 'Alquiler/Hogar',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.rent,
      iconCodePoint: Icons.home.codePoint,
    ),
    Category(
      name: 'Transporte',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.transport,
      iconCodePoint: Icons.directions_car.codePoint,
    ),
    Category(
      name: 'Salud',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.health,
      iconCodePoint: Icons.local_hospital.codePoint,
    ),
    Category(
      name: 'Entretenimiento',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.entertaiment,
      iconCodePoint: Icons.movie.codePoint,
    ),
    Category(
      name: 'Ahorro',
      type: TransactionType.expense,
      subCategory: ExpenseSubCategory.savings,
      iconCodePoint: Icons.savings.codePoint,
    ),
  ];

  // --- INGRESOS ---
  static final List<Category> incomes = [
    Category(
      name: 'Salario',
      type: TransactionType.income,
      subCategory: IncomeSubCategory.salary,
      iconCodePoint: Icons.attach_money.codePoint,
    ),
    Category(
      name: 'Freelance/Negocios',
      type: TransactionType.income,
      subCategory: IncomeSubCategory.freelance,
      iconCodePoint: Icons.laptop_mac.codePoint,
    ),
    Category(
      name: 'Inversiones',
      type: TransactionType.income,
      subCategory: IncomeSubCategory.investment,
      iconCodePoint: Icons.trending_up.codePoint,
    ),
    Category(
      name: 'Regalos',
      type: TransactionType.income,
      subCategory: IncomeSubCategory.gift,
      iconCodePoint: Icons.card_giftcard.codePoint,
    ),
  ];
}