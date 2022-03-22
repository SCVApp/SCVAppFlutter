import 'package:flutter/material.dart';

class SettingsUserCard extends StatelessWidget {
  Color cardColor;
  double cardRadius;
  Color backgroundMotifColor;
  Widget cardActionWidget;
  String userName;
  Widget userMoreInfo;
  ImageProvider userProfilePic;

  SettingsUserCard({
    this.cardColor,
    this.cardRadius = 30,
    this.userName,
    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,
    this.userMoreInfo,
    this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    if (this.userMoreInfo == null) this.userMoreInfo = Container();
    return Container(
      height: mediaQueryHeight / 4,
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(mediaQueryHeight/2),
                        child: Image(
                          image: userProfilePic,
                          height: 120,
                        ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQueryHeight / 31,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          userMoreInfo,
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
