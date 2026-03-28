class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String emoji; // Un pequeño toque visual

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.emoji,
  });

  // Calcula el porcentaje (0.0 a 1.0)
  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
  
  // Formato de texto para el UI
  String get progressText => "${(progress * 100).toInt()}%";
}