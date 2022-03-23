import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:scv_app/easistent.dart';
import 'package:scv_app/presentation/ea_flutter_icon.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/theme.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'malice.dart';
import 'nastavitve.dart';
import 'domov.dart';
import 'urnik.dart';
import 'data.dart';
import 'isci.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:get/get.dart';

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

  ThemeMode themeMode = ThemeMode.system;

  void isLogedIn() async {
    if(await aliJeUporabnikPrijavljen()){
        presented = MyHomePage();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      bool isDark = prefs.getBool(keyForThemeDark);
      if(isDark==true){
        themeMode = ThemeMode.dark;
      }else if(isDark==false){
        themeMode = ThemeMode.light;
      }
    }catch (e){
      print(e);
    }
      setState(() {
        isLoading = false;
      });
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: isLoading ? CircularProgressIndicator() : presented,
      debugShowCheckedModeBanner: false,
      theme:Themes.light,
      darkTheme: Themes.dark,
      themeMode: themeMode,
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
      // _childrenWidgets.add(new IsciPage());
      _childrenWidgets.add(new EasistentPage());
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

    return Scaffold(
      backgroundColor: selectedIndex==0? data.schoolData.schoolColor: Theme.of(context).backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: selectedIndex == 0 ?SystemUiOverlayStyle.light : Theme.of(context).backgroundColor == Colors.black ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
         child: Center(
            child: SafeArea(child: isLoading ? CircularProgressIndicator() : _childrenWidgets[selectedIndex])
          ),
      ),

      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Theme.of(context).bottomAppBarColor,
          selectedItemBorderColor: Theme.of(context).bottomAppBarColor,
          selectedItemBackgroundColor: data.schoolData.schoolColor,
          selectedItemIconColor: Theme.of(context).bottomAppBarColor,
          selectedItemLabelColor: Theme.of(context).primaryColor,
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
          /* FFNavigationBarItem(
            iconData: Icons.person_search,
            label: 'P.O.',
          ), */
          FFNavigationBarItem(
            iconData: FluttereAIcon.ea,
            label: 'eAsistent',
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
