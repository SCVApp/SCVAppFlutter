import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Data/data.dart';
import 'DoorCardWidget.dart';

class DoorCardsWidget extends StatefulWidget {
  DoorCardsWidget({Key key}) : super(key: key);

  _DoorCardsWidget createState() => _DoorCardsWidget();
}

class _DoorCardsWidget extends State<DoorCardsWidget> {
  double selectedCard = 0;

  @override
  void initState() {
    super.initState();
  }

  changeSelectedCard(int index) {
    setState(() {
      selectedCard = index.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          clipBehavior: Clip.none,
          height: (MediaQuery.of(context).size.width * 0.5) + 20,
          child: PageView(
            onPageChanged: changeSelectedCard,
            scrollDirection: Axis.horizontal,
            children: [
              //Prva, vzorcna stran kartice
              DoorCardWidget(
                context,
                HexColor.fromHex("#ca3a66"),
                Image.asset(
                  'assets/pp.png',
                ),
              ),
              //Druga, NFC kartica
              DoorCardWidget(
                context,
                HexColor.fromHex("#0094d9"),
                Image.asset(
                  'assets/nfc_glavna.png',
                ),
              ),
              //Tretja, QR koda
              DoorCardWidget(
                  context,
                  HexColor.fromHex("#0094d9"),
                  SizedBox(
                    child: QrImage(
                      foregroundColor: Theme.of(context).primaryColor,
                      data: 'https://app.scv.si',
                      version: QrVersions.auto,
                      gapless: false,
                    ),
                  ),
                  padding: 25),
            ],
          )),
      DotsIndicator(
        dotsCount: 3,
        position: selectedCard,
      )
    ]);
  }
}
