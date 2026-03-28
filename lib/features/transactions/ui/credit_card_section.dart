// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';

const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);

class CreditCardSection extends StatefulWidget {
  final bool expandedValue; // El estado real
  final Function(bool) onExpandedChanged; // La función para avisar al padre

  const CreditCardSection({
    super.key,
    required this.expandedValue,
    required this.onExpandedChanged,
  });

  @override
  State<CreditCardSection> createState() => _CardSelectionUIState();
}

class _CardSelectionUIState extends State<CreditCardSection> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    // if(screenSize.width > oneColumnLayout) {
    // } else {
        // one colum layout
    // }
    return Stack(
      children: [
        SizedBox.expand(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), 
            child: Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      widget.onExpandedChanged(!widget.expandedValue);
                    },
                    onLongPress: () {
                      showAboutDialog(
                        context: context,
                        anchorPoint: Offset.fromDirection(12),
                        children: [
                          Dialog(backgroundColor: Colors.pink, elevation: 4.0),
                        ],
                      );
                    },
                    child: CreditCardWidget(
                      // glassmorphismConfig: Glassmorphism.defaultConfig(),
                      enableFloatingCard: true,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView:
                          isCvvFocused, // Cambia a la vista trasera si el CVV tiene foco
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      isSwipeGestureEnabled: false,
                      height: kCardHeight,
                      width: kCardWidth,
                      cardBgColor: Color(0x00000000),
                      // glassmorphismConfig: Glassmorphism.defaultConfig(),
                    ),
                  ),
                  if (!widget.expandedValue)
                    CreditCardForm(
                      formKey: formKey, // Muy importante para la validación
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      onCreditCardModelChange:
                          onCreditCardModelChange, // Función que actualiza el estado
                      obscureCvv: true,
                      obscureNumber: true,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print('¡Tarjeta válida!');
                      }
                    },
                    child: const Text('Validar'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        !widget.expandedValue
            ? Positioned(
                top: 190,
                left: 10,
                child: TextButton.icon(
                  onPressed: () {},
                  label: Icon(
                    Icons.check_circle,
                    color: const Color.fromARGB(167, 102, 187, 106),
                    size: 22,
                  ),
                ),
              )
            : Positioned(
                top: 190,
                left: 10,
                child: TextButton.icon( 
                  onPressed: () {
                    widget.onExpandedChanged(!widget.expandedValue);
                  },
                  label: Text('Toca para abrir', style: TextStyle(color: AppColors.textHint,),),
                  icon: Icon(
                    Icons.touch_app_rounded,
                    color: AppColors.textHint,
                    size: 28,
                  ),
                ),
                
              ),
      ],
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CreditCardWidget(
        cardNumber: '374245455400126',
        expiryDate: '05/2023',
        cardHolderName: 'ducthu.dev',
        cvvCode: '123',
        showBackView: false,
        isSwipeGestureEnabled: false,
        height: kCardHeight,
        width: kCardWidth,
        cardBgColor: backgroundColor,
        onCreditCardWidgetChange: (_) {},
      ),
    );
  }
}
