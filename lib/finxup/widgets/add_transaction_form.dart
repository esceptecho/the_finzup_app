// ignore_for_file: deprecated_member_use

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:the_finzup_app/finxup/widgets/custom_animation_dialog.dart';
import 'package:intl/intl.dart'; // Necesitarás esto para formatear la fecha (ej: "12 Oct, 2023")
import '../models/transaction.dart';
import '../models/bill.dart'; // IMPORTANTE: Importa tu modelo Bill
import '../theme/app_theme.dart';

class AddTransactionForm extends StatefulWidget {
  final Function(Transaction) onAdd;
  final Function(Bill) onAddBill; // Añadido para soportar facturas
  final Transaction? initialTransaction; // Si es null, es modo "Crear"
  final Bill? initialBill;
  final bool isBillMode; // Estado para el Switch

  const AddTransactionForm({
    super.key,
    required this.onAdd,
    required this.onAddBill,
    this.initialTransaction,
    this.initialBill,
    required this.isBillMode,
  });

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionCategory _selectedCategory = TransactionCategory.expense;

  bool _createCalendarReminder = true; // Por defecto activado para facturas
  // 1. Estado para la fecha seleccionada (por defecto hoy)
  DateTime _selectedDate = DateTime.now();

  String _selectedRecurrence = 'Diario';
  final List<String> _recurrenceOptions = [
    'Diario',
    'Semanal',
    'Mensual',
    'Única vez',
  ];


  // 2. Método para abrir el DatePicker
  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Permite fechas muy en el pasado
      lastDate: DateTime(2100), // Permite fechas muy en el futuro
      // Personalizamos los colores para que haga match con tu AppTheme
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryWine, // Color de cabecera y botones
              onPrimary: Colors.white,
              surface: AppTheme.surface, // Fondo del calendario
              onSurface: AppTheme.textWhite,
            ),
            dialogBackgroundColor: AppTheme.surface,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _crearRecordatorioCalendario({
    required String titulo,
    required double monto,
    required DateTime fecha,
    String frecuencia = 'Única vez', // Nuevo parámetro
  }) {
    Recurrence? recurrence;

    // Configuramos la regla de repetición
    if (frecuencia == 'Semanal') {
      recurrence = Recurrence(frequency: Frequency.weekly);
    } else if (frecuencia == 'Mensual') {
      recurrence = Recurrence(frequency: Frequency.monthly);
    }

    final Event event = Event(
      title: '🔴 Pagar: $titulo',
      description:
          'Monto: \$${monto.toStringAsFixed(2)}\nGenerado desde FINXUP',
      startDate: fecha,
      endDate: fecha.add(
        const Duration(hours: 1),
      ), // iOS requiere una hora de fin
      allDay: true,
      recurrence: recurrence, // <--- Aquí sucede la magia de la repetición
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 8,
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
          ListTile(
            title: Text(
              widget.isBillMode ? "Nueva Factura" : "Nueva Transacción",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textWhite,
              ),
            ),
            subtitle: Text(
              widget.isBillMode
                  ? "Se guardará como pendiente"
                  : "Afectará tu balance actual",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: (!widget.isBillMode)
                ? Text(' ⬆⬇', style: TextStyle(fontSize: 24))
                : SizedBox(
                    height: 45,
                    
                    child: DropdownButton<String>(
                      value: _selectedRecurrence,
                      items: _recurrenceOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRecurrence = newValue!;
                        });
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 4),

          TextField(
            controller: _descController,
            cursorColor: AppTheme.textWhite,
            decoration: InputDecoration(
              labelText: _selectedCategory == TransactionCategory.income
                  ? 'Descripción del ingreso'
                  : 'Descripción del gasto',
              labelStyle: TextStyle(color: Colors.white60),
              visualDensity: .compact,
            ),
            style: const TextStyle(color: AppTheme.textWhite),
            maxLength: 50,
          ),

          // Campo Monto
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            cursorColor: AppTheme.textWhite,
            decoration: const InputDecoration(
              labelText: 'Monto (\$)',
              labelStyle: TextStyle(color: Colors.white60),
              visualDensity: .compact,
            ),
            style: const TextStyle(color: AppTheme.textWhite),
            maxLength: 8,
          ),
          const SizedBox(height: 8),

          // 3. El Selector de Fecha Visual
          Row(
            children: [
              Expanded(
                child: Text(
                  // Intl formatea la fecha para que se vea bonita
                  widget.isBillMode
                      ? 'Vencimiento: ${DateFormat.yMMMd('es_ES').format(_selectedDate)}'
                      : 'Fecha: ${DateFormat.yMMMd('es_ES').format(_selectedDate)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.calendar_month,
                  color: AppTheme.incomeGreen,
                ),
                label: const Text(
                  'Elegir Fecha',
                  style: TextStyle(color: AppTheme.incomeGreenDark),
                ),
                onPressed: _presentDatePicker,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mostrar el Switch solo si es una Factura
          if (widget.isBillMode) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Crear recordatorio en calendario",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              value: _createCalendarReminder,
              activeColor: AppTheme.incomeGreenDark,
              onChanged: (val) => setState(() => _createCalendarReminder = val),
            ),
            const SizedBox(height: 8),
          ],

          // Selector condicional: Solo se muestra si NO es modo factura
          if (!widget.isBillMode)
            Row(
              mainAxisAlignment: .spaceEvenly,

              children: [
                ChoiceChip(
                  label: const Text("Gasto"),
                  selected: _selectedCategory == TransactionCategory.expense,
                  selectedColor: AppTheme.textWhite,
                  onSelected: (_) => setState(
                    () => _selectedCategory = TransactionCategory.expense,
                  ),
                ),
                const SizedBox(width: 24),
                ChoiceChip(
                  label: const Text("Ingreso"),
                  selected: _selectedCategory == TransactionCategory.income,
                  selectedColor: AppTheme.incomeGreenDark,
                  onSelected: (_) => setState(
                    () => _selectedCategory = TransactionCategory.income,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Botón Guardar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppTheme.incomeGreenDark.withOpacity(0.5),
              ),
              onPressed: () async {
                final double? monto = double.tryParse(_amountController.text);
                if (_descController.text.isNotEmpty && monto != null) {
                  if (widget.isBillMode) {
                    // Guarda como Factura
                    await widget.onAddBill(
                      Bill(
                        id: DateTime.now().toString(),
                        title: _descController.text,
                        amount: monto,
                        dueDate: _selectedDate,
                      ),
                    );
                    // AQUÍ LLAMAMOS AL CALENDARIO SI EL SWITCH ESTÁ ACTIVO
                    if (_createCalendarReminder) {
                      _crearRecordatorioCalendario(
                        titulo: _descController.text,
                        monto: monto,
                        fecha: _selectedDate,
                        frecuencia:
                            _selectedRecurrence, // <--- Pasas la frecuencia elegida
                      );
                    }
                  } else {
                    // Guarda como Transacción
                    await widget.onAdd(
                      Transaction(
                        description: _descController.text,
                        icon: _selectedCategory == TransactionCategory.expense
                            ? Icons.shopping_cart
                            : Icons.attach_money,
                        category: _selectedCategory,
                        monto: monto,
                        date: _selectedDate,
                      ),
                    );
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  // Mostrar el diálogo de éxito
                  CustomDialogHelper.showAnimated(
                    context,
                    title: widget.isBillMode
                        ? 'Factura guardada'
                        : 'Transacción guardada',
                    lottiePath: 'assets/lotties/Done.json',
                  );
                }
              },
              child: Text(
                "Guardar",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
