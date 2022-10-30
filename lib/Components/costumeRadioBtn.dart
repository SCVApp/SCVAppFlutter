import 'package:flutter/material.dart';

Widget CostumeRadioBtn(
    {String title = "", var value, var type, Function onChanged}) {
  return GestureDetector(
    child: Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          value == type
              ? Icon(
                  Icons.check,
                  size: 25,
                )
              : SizedBox(
                  width: 25,
                  height: 25,
                ),
          Padding(padding: EdgeInsets.only(left: 40)),
          Text(
            title ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    ),
    onTap: () {
      onChanged(type);
    },
  );
}
