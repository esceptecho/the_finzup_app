import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/models/transaction.dart'; // Para formatear la fecha

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  
  // Valores del formulario
  String _description = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;
  late Enum _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    // Inicializar con la primera subcategoría disponible según el tipo
    _selectedSubCategory = _selectedType.subCategories.first;
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Aquí creas el objeto final
      final newTransaction = Transaction(
        description: _description,
        amount: _amount,
        date: _selectedDate,
        icon: _selectedType == TransactionType.income ? Icons.attach_money : Icons.shopping_cart,
        attachments: [],
        category: Category(
          name: _selectedSubCategory.name,
          type: _selectedType,
          subCategory: _selectedSubCategory,
          iconCodePoint: _selectedType == TransactionType.income 
              ? Icons.attach_money.codePoint 
              : Icons.shopping_cart.codePoint,
        ),
      );

      Navigator.of(context).pop(newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ajustar para que el teclado no tape el formulario
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nueva Transacción', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              
              // Selector de Tipo (Gasto / Ingreso)
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(value: TransactionType.expense, label: Text('Gasto'), icon: Icon(Icons.remove_circle_outline)),
                  ButtonSegment(value: TransactionType.income, label: Text('Ingreso'), icon: Icon(Icons.add_circle_outline)),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<TransactionType> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                    _selectedSubCategory = _selectedType.subCategories.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Campo de Descripción
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingresa una descripción' : null,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 15),

              // Campo de Monto
              TextFormField(
                decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ ', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) return 'Monto inválido';
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 15),

              // Selector de Subcategoría Dinámico
              DropdownButtonFormField<Enum>(
                initialValue: _selectedSubCategory,
                decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                items: _selectedType.subCategories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase()));
                }).toList(),
                onChanged: (value) => setState(() => _selectedSubCategory = value!),
              ),
              const SizedBox(height: 15),

              // Selector de Fecha
              ListTile(
                title: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                onTap: _presentDatePicker,
              ),
              const SizedBox(height: 25),

              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.burgundyDark,),
                  child: const Text('Guardar Transacción', style: TextStyle(color: AppColors.colorEFEFED,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}