import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../components/backButton.dart';
import '../../global/global.dart' as global;

class AboutAppPage extends StatefulWidget {
  AboutAppPage({Key? key}) : super(key: key);

  _AboutAppPage createState() => _AboutAppPage();
}

Future<void> _onOpen(LinkableElement link) async {
  if (await canLaunchUrl(Uri.parse(link.url))) {
    await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $link';
  }
}

class _AboutAppPage extends State<AboutAppPage> {
  int selectedPickerItem = 0;

  String token = "";

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterBuild);
  }

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
                    text: (AppLocalizations.of(context)!.about_app_desc)
                        
                    // textAlign: TextAlign.justify,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text((AppLocalizations.of(context)!.useful_links),
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
                        "ŠCVApp, $currentYear. ${(AppLocalizations.of(context)!.all_rights_reserved)} v${global.appVersion}",
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
                    "ŠCVApp, $currentYear. ${(AppLocalizations.of(context)!.all_rights_reserved)} v${global.appVersion}",
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
            Text((AppLocalizations.of(context)!.web_page)),
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
            Text((AppLocalizations.of(context)!.user_guide)),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                (AppLocalizations.of(context)!.click_here),
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((AppLocalizations.of(context)!.privacy_policy)),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                (AppLocalizations.of(context)!.click_here),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si/policy"),
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
            Text((AppLocalizations.of(context)!.web_page)),
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
            Text((AppLocalizations.of(context)!.user_guide)),
            GestureDetector(
              child: Text(
                (AppLocalizations.of(context)!.click_here),
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text((AppLocalizations.of(context)!.privacy_policy)),
            GestureDetector(
              child: Text(
                (AppLocalizations.of(context)!.click_here),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                launchUrl(Uri.parse("https://app.scv.si/policy"),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        ),
      ),
    ];
  }
}
