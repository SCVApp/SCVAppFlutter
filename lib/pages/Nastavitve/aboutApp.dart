import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global/global.dart' as global;

import '../../components/backButton.dart';

class AboutAppPage extends StatefulWidget {
  AboutAppPage({Key key}) : super(key: key);

  _AboutAppPage createState() => _AboutAppPage();
}

Future<void> _onOpen(LinkableElement link) async {
  if (await canLaunchUrl(Uri.parse(link.url))) {
    // await launch(link.url);
  } else {
    throw 'Could not launch $link';
  }
}

class _AboutAppPage extends State<AboutAppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterBuild);
  }

  bool _value = true;

  bool isListViewBigger = true;

  int currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    odpriLink(link) async {
      if (link.url == "mailto:info.app@scv.si") {
        if (!await launchUrl(Uri.parse(link.url),
            mode: LaunchMode.externalApplication)) {
          print("Email can't be opened");
        }
      }
    }

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          backButton(context),
          Expanded(
              child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 35),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/ikona_appa.png')),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Linkify(
                    onOpen: odpriLink,
                    text:
                        '''Aplikacija ŠCVApp je namenjena dijakom in učiteljem Šolskega centra Velenje. Ustvarila sta jo Blaž Osredkar in Urban Krepel.
                      \nAplikacija vsebuje naslednja orodja:
• dostop do sistema za prijavo na malico,
• urnik za obiskovan razred,
• hiter dostop do domače spletne strani šole,
• spletni dostop do aplikacije eAsistent,
ter nekaj uporabnih bližnjic do nastavitev šolskega uporabniškega računa.
                      \nV aplikacijo bova še naprej dodajala več uporabnih orodij. Za vsa vprašanja in pripombe sva na voljo na e-poštnem naslovu info.app@scv.si.''',
                    // textAlign: TextAlign.justify,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Uporabne povezave",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
              for (Widget i in MediaQuery.of(context).size.width < 340
                  ? smallerPhones()
                  : biggerPhones())
                i,
              isListViewBigger
                  ? Column(children: [
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Text(
                        "ŠCVApp, $currentYear. Vse pravice pridržane. v${global.appVersion}",
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20))
                    ])
                  : SizedBox(),
              Padding(padding: EdgeInsets.only(bottom: 20))
            ],
          )),
          !isListViewBigger
              ? Column(children: [
                  Text(
                    "ŠCVApp, $currentYear. Vse pravice pridržane. v${global.appVersion}",
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 5))
                ])
              : SizedBox(),
        ],
      ),
    ));
  }

  Future<void> _afterBuild(timestamp) async {
    if (scrollController.hasClients) {
      if (scrollController.position.maxScrollExtent > 0.0) {
        setState(() {
          isListViewBigger = true;
        });
      } else {
        setState(() {
          isListViewBigger = false;
        });
      }
    }
  }

  List<Widget> smallerPhones() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spletni portal ŠCVApp"),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                "https://app.scv.si",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si"),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vodič za uporabo ŠCVApp-a"),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                "Klikni tukaj",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si/o-nas"),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> biggerPhones() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Spletni portal ŠCVApp"),
            GestureDetector(
              child: Text(
                "https://app.scv.si",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si"),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Vodič za uporabo ŠCVApp-a"),
            GestureDetector(
              child: Text(
                "Klikni tukaj",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si/o-nas"),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        ),
      ),
    ];
  }
}
