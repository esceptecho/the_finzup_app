import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:the_finzup_app/features/dashboard/ui/onboardingScreens/onboarding_screen_1.dart';
import 'package:the_finzup_app/features/dashboard/ui/onboardingScreens/onboarding_screen_2.dart';
import 'package:the_finzup_app/features/dashboard/ui/onboardingScreens/onboarding_screen_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin{
  final PageController _controller = PageController();
  late final AnimationController _lottieController;
  bool onLastPage = false;


  @override
  void initState() {
    super.initState();
    // Duración por defecto, Lottie la ajustará al cargar
    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 500)
      );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _ejecutarAccion() {
    // Aquí disparas la animación cuando el usuario hace algo
    _lottieController.forward(from: 0); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              OnboardingScreen1(),
              OnboardingScreen2(),
              OnboardingScreen3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                // kip
                GestureDetector(
                  onTap: () {
                    _ejecutarAccion;
                    _lottieController.forward(from: 0).whenComplete(() async {
                      // 2. ESTO SE EJECUTA CUANDO LA ANIMACIÓN TERMINA
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      
                      if (!mounted) return; // Buena práctica antes de usar context en async
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SmoothPageIndicator(controller: _controller, count: 3, effect: ColorTransitionEffect(),),

                // next page or done
                onLastPage ?
                GestureDetector(
                  onTap: () async {
                    // 1. Iniciamos la animación desde el principio
                    _ejecutarAccion;
                    _lottieController.forward(from: 0).whenComplete(() async {
                      // 2. ESTO SE EJECUTA CUANDO LA ANIMACIÓN TERMINA
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      
                      if (!mounted) return; // Buena práctica antes de usar context en async
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  },
                  child: Text(
                    'Done', 
                    style: TextStyle(color: Colors.white),
                  ),
                ): GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: Duration(microseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text('Next', 
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onLastPage ?
          Column(
            children: [
              Lottie.asset(
                "assets/lotties/Done.json",
                repeat: false,
                controller: _lottieController,
                onLoaded: (composition) {
                  // Ajustamos la duración del controlador a la de la animación
                  _lottieController.duration = composition.duration;
                },
              ),
            ],
          ): SizedBox.shrink(),
        ],
      ),
    );
  }
}
