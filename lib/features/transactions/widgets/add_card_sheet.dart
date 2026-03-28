

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

const double kCardHeight = 225;
const double kCardWidth = 356;

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // Usamos Padding con MediaQuery para que el teclado no tape el formulario
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0x00000000),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Importante para BottomSheets
              mainAxisAlignment: .start,
              children: [
                const SizedBox(height: 20),
                CreditCardWidget(
                  // backgroundImage: 'assets/images/buho-silueta-retro.jpg',
                    glassmorphismConfig: Glassmorphism.defaultConfig(),
                    enableFloatingCard: true,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: isCvvFocused, // Cambia a la vista trasera si el CVV tiene foco
                    onCreditCardWidgetChange: (CreditCardBrand brand) {},
                    isSwipeGestureEnabled: false,
                    height: kCardHeight,
                    width: kCardWidth,
                    cardBgColor: Color(0x00000000),
                  ),
                  CreditCardForm(
                    formKey: formKey, // Muy importante para la validación
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    onCreditCardModelChange: onCreditCardModelChange, // Función que actualiza el estado
                    obscureCvv: true,
                    obscureNumber: true,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    enableCvv: true,
                    // OPTIONAL?
                    cvvValidationMessage: 'Please input a valid CVV',
                    dateValidationMessage: 'Please input a valid date',
                    numberValidationMessage: 'Please input a valid number',
                    isCardHolderNameUpperCase: true,
                    onFormComplete: () {
                    // callback to execute at the end of filling card data
                    },
                    autovalidateMode: AutovalidateMode.always,
                    disableCardNumberAutoFillHints: false,
                    inputConfiguration: const InputConfiguration(
                      cardNumberDecoration: InputDecoration(
                        labelStyle:TextStyle(color: Color.fromARGB(118, 255, 255, 255)),
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: InputDecoration(
                        labelStyle:TextStyle(color: Color.fromARGB(118, 255, 255, 255)),
                        border: OutlineInputBorder(),
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        labelStyle:TextStyle(color: Color.fromARGB(118, 255, 255, 255)),
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        labelStyle:TextStyle(color: Color.fromARGB(118, 255, 255, 255)),
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder',
                      ),
                      cardNumberTextStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                      cardHolderTextStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                      expiryDateTextStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                      cvvCodeTextStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    // FIN OPTIONAL?
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Lógica para guardar la tarjeta
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar Tarjeta'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}