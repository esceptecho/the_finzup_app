import 'package:flutter/material.dart';

class AppColors {
  // --- Colores Base (Vino Tinto Moderno) ---
  // Un tono más profundo y saturado para que no se vea "marrón" en OLED
  static const Color burgundyPrimary = Color(0xFF630D16); 
  static const Color burgundyDark = Color(0xFF3E080D);    
  static const Color burgundyLight = Color(0xFF8E1B25);   

  // --- Grises de Elevación (Arquitectura Dark Mode) ---
  // Siguiendo guías de diseño moderno (Material 3 / iOS Dark)
  static const Color color0ff0f0ff = Color(0xFF0D0D0D); // Fondo base (Scaffold)
  static const Color color0af0f0ff = Color(0xFF161616); // Superficies profundas (Bottom bars)
  static const Color color0efffaff = Color(0xFF1E1E1E); // Tarjetas/Contenedores (Más claro = más cerca)

  // --- Neutrales Refinados ---
  static const Color white = Color(0xFFF2F2F2);         // Blanco "roto" (menos fatiga visual)
  static const Color iceWhite = Color(0xFFE0E0E0);      
  static const Color black = Color(0xFF050505);         
  static const Color grey = Color(0xFF737373);          
  static const Color greyText = Color(0xFFB0B0B0);      // Gris claro para lectura cómoda
  static const Color textHint = Color(0xFF626262);      

  // --- Lógica de Tarjetas ---
  static const Color cardBgColor = Color(0xFF252525);     // Elevación superior a la base
  static const Color cardBgLightColor = Color(0xFFF5F5F5); 
  static const Color textOnBurgundy = Color(0xFFFFFFFF);  

  // --- Dorados (Estilo Champagne/Metálico) ---
  static const Color colorB58D67 = Color(0xFFC5A059);    // Más dorado, menos café
  static const Color colorE5D1B2 = Color(0xFFD9C5B2);
  static const Color colorF9EED2 = Color(0xFFF2E6CF);
  static const Color colorEFEFED = Color(0xFFE8E8E8);

  // --- Extras Sugeridos para Modernidad ---
  static const Color dividerColor = Color(0xFF2C2C2C);   // Para líneas divisorias sutiles
  static const Color surfaceOverlay = Color(0x1A630D16); // Vino con transparencia para efectos de selección
}