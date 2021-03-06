import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutAppPage extends StatefulWidget {
  AboutAppPage({Key key, this.data}) : super(key: key);

  final Data data;

  _AboutAppPage createState() => _AboutAppPage();
}


Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
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

  @override
  Widget build(BuildContext context) {
    odpriLink(link) async {
      if (link.url == "mailto:info.app@scv.si"){
        if(!await launchUrl(Uri.parse(link.url),mode: LaunchMode.externalApplication)){
          print("Email can't be opened");
        }
      }
    }

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              backButton(context),
          Expanded(child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 35),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/ikona_appa.png')),
              ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Linkify(
                  onOpen: odpriLink,
                  text: '''Aplikacija ??CVApp je namenjena dijakom in u??iteljem ??olskega centra Velenje. Ustvarila sta jo Bla?? Osredkar in Urban Krepel v sklopu svoje raziskovalne naloge.
                      \nAplikacija vsebuje naslednja orodja, koristna dijakom:
??? dostop do sistema za prijavo na malico,
??? urnik za obiskovan razred,
??? hiter dostop do doma??e spletne strani ??ole,
??? bli??njico do pregleda eAsistenta dijaka,
ter nekaj uporabnih bli??njic do nastavitev ??olskega uporabni??kega ra??una.
                      \nV aplikacijo bomo ??e naprej dodajali ve?? uporabnih orodij. Za vsa vpra??anja in pripombe smo na voljo na e-po??tnem naslovu info.app@scv.si.''',
                  // textAlign: TextAlign.justify,
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Uporabne povezave", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left)
                  ],
                ),
              ),
              for(Widget i in MediaQuery.of(context).size.width < 340 ? smallerPhones() : biggerPhones()) i,
              isListViewBigger ? Column(children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                "??CVApp, 2022. Vse pravice pridr??ane.",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(bottom: 20))]) : SizedBox(),
            Padding(padding: EdgeInsets.only(bottom: 20))
            ],
          )),
           !isListViewBigger ? Column(children: [Text(
                "??CVApp, 2022. Vse pravice pridr??ane.",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(bottom: 5))]) : SizedBox(),
        ],
        ),
          
        )
    );
  }

  Future<void> _afterBuild (timestamp) async {
    if (scrollController.hasClients) {
      if(scrollController.position.maxScrollExtent > 0.0){
        setState(() {
          isListViewBigger = true;
        });
      }else{
        setState(() {
          isListViewBigger = false;
        });
      }
    }   
  }

  

  List<Widget> smallerPhones(){
    print(MediaQuery.of(context).size.width);
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spletni portal ??CVApp"),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                "https://app.scv.si",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: (){
                launchUrl(
                Uri.parse("https://app.scv.si"),
                mode: LaunchMode.externalApplication
                );
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
            Text("Vodi?? za uporabo ??CVApp-a"),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            GestureDetector(
              child: Text(
                "Klikni tukaj",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: (){
                launchUrl(
                Uri.parse("https://app.scv.si/o-nas"),
                mode: LaunchMode.externalApplication
                );
              },
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> biggerPhones(){
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Spletni portal ??CVApp"),
            GestureDetector(
              child: Text(
                "https://app.scv.si",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: (){
                launchUrl(
                Uri.parse("https://app.scv.si"),
                mode: LaunchMode.externalApplication
                );
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
            Text("Vodi?? za uporabo ??CVApp-a"),
            GestureDetector(
              child: Text(
                "Klikni tukaj",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: (){
                launchUrl(
                Uri.parse("https://app.scv.si/o-nas"),
                mode: LaunchMode.externalApplication
                );
              },
            )
          ],
        ),
      ),
    ];
  }

  }