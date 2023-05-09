import 'package:flutter/material.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/ura.dart';
import 'package:scv_app/components/urnik/moreInfromations/doorUnlockBtn.dart';
import 'package:scv_app/components/urnik/moreInfromations/lineItem.dart';

import '../../icons/person_video_icons.dart';

class UrnikMoreInformations extends StatefulWidget {
  final Ura ura;
  final ObdobjaUr obdobjeUr;

  UrnikMoreInformations(this.ura, this.obdobjeUr);

  @override
  _UrnikMoreInformationsState createState() => _UrnikMoreInformationsState();
}

class _UrnikMoreInformationsState extends State<UrnikMoreInformations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.ura.krajsava, style: TextStyle(fontSize: 22))
                ],
              ),
              Positioned(child: BackButton())
            ],
          ),
          UrnikMoreInformationsLineItem(
              Icons.schedule, "DATUM", widget.obdobjeUr.datum),
          UrnikMoreInformationsLineItem(
              PersonVideo.person_video3, "PROFESOR", widget.ura.ucitelj),
          UrnikMoreInformationsLineItem(
              Icons.door_front_door, "UČILNICA", widget.ura.ucilnica),
          if (widget.ura.smartDoorCode != null)
            UrnikMoreInformationsDoorUnlockBtn(),
        ],
      )),
    ));
  }
}
