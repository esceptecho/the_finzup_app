// import 'package:hive/hive.dart';

// part 'transaction.g.dart'; // Archivo generado por build_runner

// // 1. Enum para el Tipo de Transacción
// @HiveType(typeId: 0)
// enum TransactionType {
//   @HiveField(0) income,
//   @HiveField(1) expense,
// }

// // 2. Modelo de Categoría
// @HiveType(typeId: 1)
// class Category {
//   @HiveField(0)
//   final String name;
  
//   @HiveField(1)
//   final TransactionType type;
  
//   @HiveField(2)
//   final int iconCodePoint; // Guardamos el codePoint del IconData para reconstruirlo en la UI

//   Category({
//     required this.name,
//     required this.type,
//     required this.iconCodePoint,
//   });
// }

// // 3. Modelo Principal de Transacción
// @HiveType(typeId: 2)
// class Transaction extends HiveObject {
//   @HiveField(0)
//   final String id;

//   @HiveField(1)
//   final String description;

//   @HiveField(2)
//   final double amount;

//   @HiveField(3)
//   final Category category;

//   @HiveField(4)
//   final List<String> attachments; // Rutas de los archivos locales (imágenes o PDFs)

//   @HiveField(5)
//   final DateTime date;

//   Transaction({
//     required this.id,
//     required this.description,
//     required this.amount,
//     required this.category,
//     required this.attachments,
//     required this.date,
//   });
// }