// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../theme/app_theme.dart';

class AddGoalForm extends StatefulWidget {
  final Function(Goal) onAdd;
  final Goal? initialGoal;

  const AddGoalForm({super.key, required this.onAdd, this.initialGoal});

  @override
  State<AddGoalForm> createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  late TextEditingController _currentController;
  late String _selectedEmoji;

  final List<String> _emojis = [
    '💰',
    '🚗',
    '🏠',
    '✈️',
    '🎓',
    '🛡️',
    '💻',
    '🚲',
  ];

  @override
  void initState() {
    super.initState();
    // Si recibimos una meta, precargamos los datos; si no, vacío.
    _titleController = TextEditingController(
      text: widget.initialGoal?.title ?? '',
    );
    _targetController = TextEditingController(
      text: widget.initialGoal?.targetAmount.toString() ?? '',
    );
    _currentController = TextEditingController(
      text: widget.initialGoal?.currentAmount.toString() ?? '',
    );
    _selectedEmoji = widget.initialGoal?.emoji ?? '🎓';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nueva Meta de Ahorro",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 20),

          // Selector de Emoji
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojis.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _selectedEmoji = _emojis[index]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedEmoji == _emojis[index]
                        ? AppTheme.primaryWine
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _emojis[index],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '¿Qué estás ahorrando?',
              floatingLabelStyle: TextStyle(
                color: AppTheme.textWhite.withOpacity(0.8),
              ),
            ),
            style: const TextStyle(color: AppTheme.textWhite),
            cursorColor: AppTheme.textWhite,
          ),
          TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Monto Objetivo (\$)',
              floatingLabelStyle: TextStyle(
                color: AppTheme.textWhite.withOpacity(0.8),
              ),
            ),
            style: const TextStyle(color: AppTheme.textWhite),
            cursorColor: AppTheme.textWhite,
          ),
          TextField(
            controller: _currentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Monto Inicial (Opcional)',
              floatingLabelStyle: TextStyle(
                color: AppTheme.textWhite.withOpacity(0.8),
              ),
            ),
            style: const TextStyle(color: AppTheme.textWhite),
            cursorColor: AppTheme.textWhite,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryWine,
              ),
              onPressed: () {
                final target = double.tryParse(_targetController.text);
                final current = double.tryParse(_currentController.text) ?? 0.0;

                if (_titleController.text.isNotEmpty && target != null) {
                  widget.onAdd(
                    Goal(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      targetAmount: target,
                      currentAmount: current,
                      emoji: _selectedEmoji,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Crear Meta",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
