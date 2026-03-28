import 'package:flutter/material.dart';

class MovementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String monto;
  final bool esGasto;
  const MovementCard({super.key, required this.icon, required this.title, required this.monto, required this.esGasto});

  // ... parámetros: icono, título, monto, esGasto
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E), // Gris Superficie
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54),
          SizedBox(width: 16),
          Text(title, style: TextStyle(color: Colors.white)),
          Spacer(),
          Text(
            monto,
            style: TextStyle(
              color: esGasto ? Color(0xFFA21B2E) : Color(0xFF48C9B0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}