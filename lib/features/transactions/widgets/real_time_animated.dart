import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/transactions/widgets/saludo.dart';

class RealTimeAnimated extends StatefulWidget {
  const RealTimeAnimated({super.key});

  @override
  State<RealTimeAnimated> createState() => _RealTimeAnimatedState();
}

class _RealTimeAnimatedState extends State<RealTimeAnimated> {
  final TextEditingController _controller = TextEditingController();
  
  // Variables de estado
  String _displayText = '';
  double _fontSize = 24;
  Color _textColor = Colors.blue;

  final List<Color> _colors = [
    Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    // Es mejor usar onChanged en el TextField, pero el listener también funciona
    _controller.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _displayText = _controller.text;
      _fontSize = (_controller.text.length * 0.5 + 24).clamp(18, 40).toDouble();
      // Evitamos error de índice si length es 0
      if (_controller.text.isNotEmpty) {
        _textColor = _colors[_controller.text.length % _colors.length];
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // El removeListener no es estrictamente necesario si haces dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Necesitamos un Scaffold para dar estructura a la pantalla
    return Scaffold(
      appBar: AppBar(title: const Text("Demo Input Animado")),
      // 3. SafeArea evita que el contenido quede bajo la barra de estado del celular
      body: SafeArea(
        // 4. SingleChildScrollView evita el error de overflow cuando sale el teclado
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Tiempo real animado',
                  hintText: 'Escribe para ver la magia...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.animation),
                  suffixIcon: _displayText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _controller.clear(),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _textColor, width: 2),
                ),
                child: Column(
                  children: [
                    const Text('📝 Preview en tiempo real:',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    // AnimatedDefaultTextStyle anima el cambio de fuente suavemente
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: _textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        _displayText.isEmpty ? '¡Escribe algo!' : _displayText,
                        textAlign: .center,
                      ),
                    ),
                    if (_displayText.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        // mostrar el número   -   decidir la palabra basándose en el número
                        '🔤 ${_displayText.length} ${_displayText.length == 1 ? 'caracter' : 'caracteres'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // Disparar BottomSheet
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent, // Para bordes redondeados personalizados
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.5, // 50% de la pantalla
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: PantallaSaludo(), // Pasando datos
                    ),
                  );
                },
                child: const Text("Ver Saludo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}