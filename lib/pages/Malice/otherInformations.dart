import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/malice/home/mealInfoBox.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/malice/malica.dart';
import '../../store/AppState.dart';

class MaliceOtherInformations extends StatefulWidget {
  MaliceOtherInformations(this.goBack, {Key? key}) : super(key: key);

  final void Function() goBack;

  @override
  _MaliceOtherInformationsState createState() =>
      _MaliceOtherInformationsState();
}

class _MaliceOtherInformationsState extends State<MaliceOtherInformations> {
  void launchHelpInBrowser() {
    launchUrl(
      Uri.parse(
        "https://malice.scv.si/instructions",
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        return Scaffold(
            body: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Icon(Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor),
                onPressed: widget.goBack,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(15),
                children: <Widget>[
                  MealInfoBox(context, "Ime in priimek:",
                      "${malica.maliceUser.firstName} ${malica.maliceUser.lastName}"),
                  MealInfoBox(context, "IBAN:",
                      "SI56 0110 0603 0705 664 (BANKA SLOVENIJE LJUBLJANA)"),
                  MealInfoBox(context, "Referenca:", "SI00 555-"),
                  MealInfoBox(context, "Pomoč", "",
                      icon: Icon(Icons.arrow_forward_ios),
                      onTap: launchHelpInBrowser),
                ].withSpaceBetween(spacing: 20),
              ),
            ),
          ],
        ));
      },
    );
  }
}
