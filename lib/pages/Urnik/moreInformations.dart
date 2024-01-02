import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/ura.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/components/urnik/moreInfromations/doorUnlockBtn.dart';
import 'package:scv_app/components/urnik/moreInfromations/lineItem.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../icons/person_video_icons.dart';

class UrnikMoreInformations extends StatefulWidget {
  final Ura ura;
  final ObdobjaUr obdobjeUr;

  UrnikMoreInformations(this.ura, this.obdobjeUr);

  @override
  _UrnikMoreInformationsState createState() => _UrnikMoreInformationsState();
}

class _UrnikMoreInformationsState extends State<UrnikMoreInformations> {
  void goToDoorUnlock() {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    windowManager.showWindow("PassDoor", attributes: {
      "uri": 'scvapp://app.scv.si/open_door/${widget.ura.smartDoorCode}'
    });
    Navigator.pop(context);
  }

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
              Icons.schedule,
              AppLocalizations.of(context)!.date.toUpperCase(),
              widget.obdobjeUr.datum),
          UrnikMoreInformationsLineItem(
              PersonVideo.person_video3,
              AppLocalizations.of(context)!.profesor.toUpperCase(),
              widget.ura.ucitelj),
          UrnikMoreInformationsLineItem(
              Icons.door_front_door,
              AppLocalizations.of(context)!.classroom.toUpperCase(),
              widget.ura.ucilnica),
          if (widget.ura.smartDoorCode != null)
            UrnikMoreInformationsDoorUnlockBtn(goToDoorUnlock,
                widget.obdobjeUr.type == ObdobjaUrType.trenutno),
        ],
      )),
    ));
  }
}
