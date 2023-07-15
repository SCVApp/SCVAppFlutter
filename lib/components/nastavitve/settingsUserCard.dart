import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scv_app/components/nastavitve/profilePictureWithStatus.dart';

class SettingsUserCard extends StatelessWidget {
  final Color cardColor;
  final double cardRadius;
  final Color backgroundMotifColor;
  final Widget? cardActionWidget;
  final String userName;
  final Widget? userMoreInfo;

  SettingsUserCard({
    required this.cardColor,
    this.cardRadius = 30,
    required this.userName,
    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,
    this.userMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Container(
      height: max(mediaQueryHeight / 4, 140),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(double.parse(cardRadius.toString())),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: backgroundMotifColor.withOpacity(.1),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 400,
              backgroundColor: backgroundMotifColor.withOpacity(.05),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: (cardActionWidget != null)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfilePictureWithStatus(context),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: max(mediaQueryHeight / 31, 16),
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          userMoreInfo ?? SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: (cardActionWidget != null)
                      ? cardActionWidget
                      : Container(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
