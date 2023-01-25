import 'package:flutter/material.dart';
import 'package:scv_app/pages/Urnik/otherDays.dart';

Widget seeOtherDays(double gap, BuildContext context) {
  void goToOtherDays() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UrnikOtherDays();
    }));
  }

  return Padding(
    child: GestureDetector(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Ogled urnika za ostale dni",
          style: TextStyle(fontSize: 15),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColor,
        ),
      ]),
      onTap: goToOtherDays,
    ),
    padding: EdgeInsets.only(left: 15, right: 15, bottom: gap),
  );
}
