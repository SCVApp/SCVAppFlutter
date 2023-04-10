import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget EPASHomeCard(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
    width: MediaQuery.of(context).size.width - 40,
    child: Column(
      children: <Widget>[
        QrImage(
          data: "https://www.google.com",
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
