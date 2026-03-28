import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';

class FactSegmentButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  final IconData icon;
  const FactSegmentButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isActive,
    required this.icon,
  });

  @override
  State<FactSegmentButton> createState() => _FactSegmentButtonState();
}

class _FactSegmentButtonState extends State<FactSegmentButton> {
  bool isChecked = false; // 1. Definir la variable de estado

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: 100,
        decoration: widget.isActive
            ? BoxDecoration(
                border: .all(color: const Color.fromARGB(115, 142, 142, 142)),
                color: AppColors.color0efffaff,
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        alignment: .center,
        child: GestureDetector(
          child: ListTile(
            leading: Icon(widget.icon),
            trailing: Checkbox(
              value: isChecked, // 2. Asignar el valor
              onChanged: (bool? newValue) {
                setState(() {
                  isChecked = newValue!; // 3. Actualizar y redibujar
                });
              },
            ),
            iconColor: Colors.white70,
            title: GestureDetector(child: Text(widget.title)),

            subtitle: Text('pending \$ amount'),
          ),
          onLongPressStart: (details) {
            // Obtenemos las coordenadas del toque
            double x = details.globalPosition.dx;
            double y = details.globalPosition.dy;

            showMenu(
              context: context,
              // Creamos un pequeño rectángulo en el punto del toque
              position: RelativeRect.fromLTRB(x, y, x, y),
              items: [
                const PopupMenuItem(child: Text("Editar")),
                const PopupMenuItem(child: Text("Eliminar")),
                const PopupMenuItem(child: Text("Guardar")),
              ],
            );
          },
        ),
      ),
    );
  }
}


