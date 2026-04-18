import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/transactions/ui/credit_card_section.dart';
import 'package:the_finzup_app/features/transactions/widgets/goal_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  bool _isCardExpanded = true; // El estado vive aquí

  // Lista de banners con contenido financiero real
  final List<GoalBanner> goalBannerList = const [
    GoalBanner(
      icon: Icons.trending_down,
      color: Color(0xFFE57373),
      text:
          '¡Cuidado! Tus gastos en "Salidas" superaron el presupuesto este mes.',
    ),
    GoalBanner(
      icon: Icons.lightbulb_outline,
      color: Color(0xFF64B5F6),
      text:
          'Tip: Activa el ahorro automático y olvídate de transferir manualmente.',
    ),
    GoalBanner(
      icon: Icons.analytics,
      color: Color(0xFF81C784),
      text:
          'Tu patrimonio neto creció un 3% respecto al mes pasado. ¡Sigue así!',
    ),
    GoalBanner(
      icon: Icons.support_agent,
      color: Color(0xFFFFB74D),
      text: '¿Dudas con tus impuestos? Habla con nuestro asesor financiero IA.',
    ),
    GoalBanner(
      icon: Icons.security,
      color: Color(0xFF9575CD),
      text: 'Tu fondo de emergencia ya cubre 3 meses de gastos básicos.',
    ),
    GoalBanner(
      icon: Icons.history_edu,
      color: Color(0xFF4DB6AC),
      text:
          'Revisa tu historial: Pagaste \$20 USD en suscripciones que no usas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color0ff0f0ff,
      appBar: AppBar(
        title: const Text(
          'Resumen Financiero',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SECCIÓN 1: CARRUSEL
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                itemCount: goalBannerList.length,
                onPageChanged: (int page) =>
                    setState(() => _currentPage = page),
                itemBuilder: (context, index) => goalBannerList[index],
              ),
            ),

            // Indicadores de puntos (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                goalBannerList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.colorEFEFED
                        : AppColors.textHint,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                height: _isCardExpanded ? 260 : 670,
                // height: 260,
                decoration: BoxDecoration(
                  color: AppColors.cardBgColor, // Vino tinto
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(child:
                
                 CreditCardSection(
                  expandedValue: _isCardExpanded, // Le pasas el valor
                  onExpandedChanged: (nuevoValor) {
                    setState(() {
                      _isCardExpanded = nuevoValor; // Actualizas el estado del padre
                    });
                  },
                
                ),
              ),
            ),),
            const SizedBox(height: 20),

            // SECCIÓN 2: EXPANDED 1
            SizedBox(
              height: 170,
              child: _buildSection(
                title: "Balance General",
                icon: Icons.account_balance_wallet,
                content: "\$12,450.00",
                color: AppColors.grey,
              ),
            ),

            // SECCIÓN 3: EXPANDED 2
            SizedBox(
              height: 170,
              child: _buildSection(
                title: "Gastos por Categoría",
                icon: Icons.pie_chart,
                content: "Comida: 30% | Renta: 50%",
                color: AppColors.colorB58D67,
              ),
            ),

            // SECCIÓN 4: EXPANDED 3
            SizedBox(
              height: 170,
              child: _buildSection(
                title: "Metas de Ahorro",
                icon: Icons.flag,
                content: "Viaje Japón: 65% completado",
                color: AppColors.burgundyLight,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
