import 'package:flutter/material.dart';


class PantallaSaludo extends StatefulWidget {
  const PantallaSaludo({super.key});

  @override
  State<PantallaSaludo> createState() => _PantallaSaludoState();
}

class _PantallaSaludoState extends State<PantallaSaludo> {
  // 1. Controlador para recuperar el texto final cuando se presiona el botón
  final TextEditingController _controller = TextEditingController();

  // Variables para guardar el estado
  String _nombreEnTiempoReal = ""; // Se actualiza letra por letra
  String _nombreFinal = "";        // Se actualiza solo al dar click en el botón
  bool _mostrarSaludo = false;     // Controla la visibilidad del widget animado

  @override
  void dispose() {
    // Siempre limpia el controlador cuando el widget se destruye para liberar memoria
    _controller.dispose();
    super.dispose();
  }

  void _actualizarSaludo() {
    setState(() {
      _nombreFinal = _controller.text; // Obtenemos el texto del controlador
      _mostrarSaludo = true;           // Activamos la animación
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input y Animación Flutter")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            // --- INPUT (TEXTFIELD) ---
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe tu nombre aquí',
                prefixIcon: Icon(Icons.person),
              ),
              // Lógica para tiempo real:
              onChanged: (textoIngresado) {
                setState(() {
                  _nombreEnTiempoReal = textoIngresado;
                  // Si borran todo, ocultamos el saludo final
                  if (textoIngresado.isEmpty) _mostrarSaludo = false;
                });
              },
            ),
            
            const SizedBox(height: 20),

            // --- VISUALIZACIÓN EN TIEMPO REAL ---
            Text(
              "Estás escribiendo: $_nombreEnTiempoReal",
              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 20),

            // --- BOTÓN DE ACCIÓN ---
            ElevatedButton(
              onPressed: _actualizarSaludo,
              child: const Text("Saludar"),
            ),

            const SizedBox(height: 40),
            // --- WIDGET ANIMADO (RESULTADO) ---
            // AnimatedOpacity hace que el widget aparezca suavemente (Fade In)
            AnimatedOpacity(
              opacity: _mostrarSaludo ? 1.0 : 0.0, 
              duration: const Duration(milliseconds: 800), // Duración de la animación
              curve: Curves.easeIn,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, spreadRadius: 5)
                  ]
                ),
                child: Text(
                  "¡Hola, $_nombreFinal!",
                  style: const TextStyle(
                    fontSize: 24, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}