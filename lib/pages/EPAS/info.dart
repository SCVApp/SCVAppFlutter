import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class EPASInfoPage extends StatelessWidget {
  void _onOpen(LinkableElement link) async {
    if (link.url == "mailto:info.app@scv.si") {
      if (!await launchUrl(Uri.parse(link.url),
          mode: LaunchMode.externalApplication)) {
        print("Email can't be opened");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Evropa na dlani",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ]),
          Padding(
            child: Linkify(
              onOpen: this._onOpen,
              text: """
Evropa na dlani je projekt, ki so ga pripravili dijaki ambasadorji Evropskega parlamenta ŠC Velenje, eMCe plac in prostovoljci Šolskega centra Velenje.

OPIS DEJAVNOSTI:


Dijaki ambasadorji Evropskega parlamenta bodo pripravili 11 stojnic, kjer bodo z ekonomskega, turističnega in gastronomskega vidika predstavili 11 držav EU ( Hrvaška, Avstrija, Italija, Španija, Luksemburg, Nizozemska, Belgija, Nemčija, Francija, Madžarska, Slovenija). Na stojnicah bodo potekale delavnice. Vsak dijak se preko aplikacije prijavi na delavnice štirih držav in se ob določeni uri udeleži delavnice, ki bodo trajale 30 minut in bodo potekale od 10.30 do 12.30. Navodila za aplikacijo in prijavo bodo dijakom dale učiteljice aktivnega državljanstva. Dijaki boste dobili kartončke, na katere boste po opravljenih delavnicah prejeli pri vsaki stojnici dva žiga s podpisi. Aktivnost se bo dijakom priznala za opravljeno, ko bodo oddali kartončke z osmimi žigi in podpisi.

Za več informacij ali pomoč piši na: info.app@scv.si
        """,
              textAlign: TextAlign.justify,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          )
        ])),
      ),
    );
  }
}
