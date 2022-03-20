import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'malice.dart';
import 'nastavitve.dart';
import 'domov.dart';
import 'urnik.dart';
import 'data.dart';
import 'isci.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DarkLightTheme();
  }
}

class DarkLightTheme extends StatefulWidget {
  const DarkLightTheme({
    Key key,
  }) : super(key: key);

  @override
  State<DarkLightTheme> createState() => _DarkLightThemeState();
}

class _DarkLightThemeState extends State<DarkLightTheme> {

  @override
  void initState() {
    super.initState();
    isLogedIn();
  }

  Widget presented = OnBoardingPage();

  void isLogedIn() async {
    if(await aliJeUporabnikPrijavljen()){
        presented = MyHomePage();
    }
      setState(() {
        isLoading = false;
      });
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoading ? CircularProgressIndicator() : presented,
      debugShowCheckedModeBanner: false,
      
      
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  Data data = new Data();
  bool isLoading = true;
  bool noUser = false;

  final List<Widget> _childrenWidgets = [];

  @override
  void initState() {
    super.initState();
    loadDataToScreen();
  }

  void loadDataToScreen() async{
    if(!await this.data.loadData()){
      setState(() {
        noUser = true;
      });
    }
    setState(() {
      _childrenWidgets.add(new DomovPage(data: data));
      _childrenWidgets.add(new MalicePage());
      _childrenWidgets.add(new IsciPage());
      _childrenWidgets.add(new UrnikPage(data: data));
      _childrenWidgets.add(new NastavitvePage(data: data));
      isLoading = false;
    });
  }


  void changeView(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(noUser){
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }


    return Scaffold(
      backgroundColor: selectedIndex==0? data.schoolData.schoolColor:Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: selectedIndex == 0 ?SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,                
         child: Center(
            child: SafeArea(child: isLoading ? CircularProgressIndicator() : _childrenWidgets[selectedIndex])
          ),
      ),

      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.white,
          selectedItemBackgroundColor: data.schoolData.schoolColor,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home_rounded,
            label: 'Domov',
          ),
          FFNavigationBarItem(
            iconData: Icons.fastfood,
            label: 'Malice',
          ),
          FFNavigationBarItem(
            iconData: Icons.person_search,
            label: 'P.O.',
          ),
          FFNavigationBarItem(
            iconData: Icons.calendar_today_rounded,
            label: 'Urnik',
          ),
          FFNavigationBarItem(
            iconData: Icons.settings,
            label: 'Nastavitve',
          ),
        ],
      ),
    );
  }
}
