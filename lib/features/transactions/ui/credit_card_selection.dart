import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);

class CreditCardData {
  CreditCardData({required this.backgroundColor});
  final Color backgroundColor;
}

class CardSelectionUI extends StatefulWidget {
  const CardSelectionUI({
    super.key,
  });

  @override
  State<CardSelectionUI> createState() => _CardSelectionUIState();
}

class _CardSelectionUIState extends State<CardSelectionUI> {
  int? selectedCardIndex;

  final double space = kSpaceBetweenCard;

  final cardData = [
    CreditCardData(
      backgroundColor: Colors.orange,
    ),
    CreditCardData(
      backgroundColor: Colors.grey.shade900,
    ),
    CreditCardData(
      backgroundColor: Colors.cyan,
    ),
    CreditCardData(
      backgroundColor: Colors.blue,
    ),
    CreditCardData(
      backgroundColor: Colors.purple,
    ),
  ];

  late final List<CreditCard> creditCards;

  @override
  void initState() {
    super.initState();

    creditCards = cardData
        .map(
          (data) => CreditCard(
            backgroundColor: data.backgroundColor,
          ),
        )
        .toList();
  }

  int toUnselectedCardPositionIndex(int indexInAllList) {
    if (selectedCardIndex != null) {
      if (indexInAllList < selectedCardIndex!) {
        return indexInAllList;
      } else {
        return indexInAllList - 1;
      }
    } else {
      throw 'Wrong usage';
    }
  }

  double _getCardTopPosititoned(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return space;
      } else {
        /// Space from top to place put unselect cards.
        return kSpaceUnselectedCardToTop +
            toUnselectedCardPositionIndex(index) * kSpaceBetweenUnselectCard;
      }
    } else {
      /// Top first emptySpace + CardSpace + emptySpace + ...
      return space + index * kCardHeight + index * space;
    }
  }

  double _getCardScale(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return 1.0;
      } else {
        int totalUnselectCard = creditCards.length - 1;
        return 1.0 -
            (totalUnselectCard - toUnselectedCardPositionIndex(index) - 1) *
                0.05;
      }
    } else {
      return 1.0;
    }
  }

  void unSelectCard() {
    setState(() {
      selectedCardIndex = null;
    });
  }

  double totalHeightTotalCard() {
    if (selectedCardIndex == null) {
      final totalCard = creditCards.length;
      return space * (totalCard + 1) + kCardHeight * totalCard;
    } else {
      return kSpaceUnselectedCardToTop +
          kCardHeight +
          (creditCards.length - 2) * kSpaceBetweenUnselectCard +
          kSpaceBetweenCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: kAnimationDuration,
              height: totalHeightTotalCard(),
              width: mediaQuery.size.width,
            ),
            for (int i = 0; i < creditCards.length; i++)
              AnimatedPositioned(
                top: _getCardTopPosititoned(i, i == selectedCardIndex),
                duration: kAnimationDuration,
                child: AnimatedScale(
                  scale: _getCardScale(i, i == selectedCardIndex),
                  duration: kAnimationDuration,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCardIndex = i;
                      });
                    },
                    child: creditCards[i],
                  ),
                ),
              ),
            if (selectedCardIndex != null)
              Positioned.fill(
                  child: GestureDetector(
                onVerticalDragEnd: (_) {
                  unSelectCard();
                },
                onVerticalDragStart: (_) {
                  unSelectCard();
                },
              ))
          ],
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({
    super.key,
    required this.backgroundColor,
  });

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
