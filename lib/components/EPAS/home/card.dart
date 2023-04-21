import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';

Widget EPASHomeCard(BuildContext context) {
  return FloatingCard(
    context,
    child: Column(
      children: <Widget>[
        QrImage(
          data: "436218",
          size: 170,
          embeddedImage: AssetImage("assets/images/1024.png"),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Wrap(
          children: [
            Text("KODA: "),
            Text(
              "436 218",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    ),
  );
}
