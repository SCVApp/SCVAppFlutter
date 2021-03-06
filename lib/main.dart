import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:scv_app/Components/NavBarItemv2.dart';
import 'package:scv_app/easistent.dart';
import 'package:scv_app/presentation/ea_flutter_icon.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/theme.dart';
import 'package:scv_app/uvod.dart';
import 'package:scv_app/zaklep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'malice.dart';
import 'nastavitve.dart';
import 'domov.dart';
import 'urnik.dart';
import 'data.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
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
  bool isBioLock = false;

  void isLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isBio = prefs.getBool(keyForUseBiometrics);
      if (isBio == true) {
        isBioLock = true;
      } else if (isBio == false) {
        isBioLock = false;
      }
    } catch (e) {
      print(e);
    }
    if (await aliJeUporabnikPrijavljen()) {
      presented = isBioLock ? ZaklepPage() : MyHomePage();
    }
    try {
      bool isDark = prefs.getBool(keyForThemeDark);
      if (isDark == true) {
        themeMode = ThemeMode.dark;
      } else if (isDark == false) {
        themeMode = ThemeMode.light;
      }
    } catch (e) {
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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: isLoading ? CircularProgressIndicator() : presented,
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: themeMode,
      supportedLocales: [
        Locale("sl")
      ],
      locale: Locale("sl"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  int selectedIndex = 0;
  Data data = new Data();
  bool isLoading = true;
  bool noUser = false;
  CacheData cacheData = new CacheData();

  final List<Widget> _childrenWidgets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadDataToScreen();
  }

  void loadDataToScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyForAppAutoLock);
    CacheData cacheData2 = new CacheData();
    await cacheData2.getData();
    setState(() {
      cacheData = cacheData2;
      _childrenWidgets.add(new DomovPage(cacheData: cacheData,));
      _childrenWidgets.add(new MalicePage());
      // _childrenWidgets.add(new IsciPage());
      _childrenWidgets.add(new EasistentPage());
      _childrenWidgets.add(new UrnikPage(cacheData: cacheData));
      _childrenWidgets.add(new NastavitvePage(cacheData: cacheData));
      isLoading = false;
    });
    if (!await this.data.loadData(cacheData)) {
      setState(() {
        noUser = true;
      });
      prefs.remove(keyForAccessToken);
      prefs.remove(keyForRefreshToken);
      prefs.remove(keyForExpiresOn);
      prefs.remove(keyForThemeDark);
      prefs.remove(keyForUseBiometrics);
      cacheData.deleteKeys(prefs);

      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }
    setState(() {
        DomovPage page = _childrenWidgets[0];
        page.updateData(data);
        UrnikPage page2 = _childrenWidgets[3];
        page2.updateData(data);
        NastavitvePage page3 = _childrenWidgets[4];
        page3.updateData(data);
    });
    var prevS = selectedIndex;
    if(prevS != 0){
      setState(() {
        selectedIndex = 0;
      });
      await Future.delayed(Duration(milliseconds: 10));
      setState(() {
        selectedIndex=prevS;
      });
    }else if(cacheData.schoolUrl == ""){
      setState(() {
        selectedIndex = 1;
      });
      await Future.delayed(Duration(milliseconds: 10));
      setState(() {
        selectedIndex=prevS;
      });
    }
  }

  void changeView(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try{
        final expiresOn = prefs.getString(keyForExpiresOn);
        DateTime expiredDate = new DateFormat("EEE MMM dd yyyy hh:mm:ss").parse(expiresOn).toUtc().subtract(Duration(minutes:5));
        DateTime zdaj = new DateTime.now().toUtc();
        if(zdaj.isAfter(expiredDate)){
          await refreshToken();
        }
      }catch(e){
        print(e);
      }

      try{
        bool isBio = prefs.getBool(keyForUseBiometrics);
        int autoLock = prefs.getInt(keyForAppAutoLock);
        int zdaj = new DateTime.now().toUtc().millisecondsSinceEpoch;
        if(isBio == true){
          prefs.remove(keyForAppAutoLock);
          if(zdaj >= autoLock){
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ZaklepPage(isFromAutoLock: true,)));
          }
        }
      }catch(e){
        print(e);
      }
    }else if(state == AppLifecycleState.paused){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int minuts=5;
      try{
        int minutuesToAutoLOCK = prefs.getInt(keyForAppAutoLockTimer);
        if(minutuesToAutoLOCK == 0){
          minuts = 0;
          prefs.setInt(keyForAppAutoLock, new DateTime.now().toUtc().millisecondsSinceEpoch);
          return;
        }else if(minutuesToAutoLOCK > 10000){
          prefs.remove(keyForAppAutoLockTimer);
          return;
        }else{
          minuts = minutuesToAutoLOCK;
        }
      }catch(e){
        minuts=5;
      }
      prefs.setInt(keyForAppAutoLock, new DateTime.now().toUtc().add(Duration(minutes:minuts)).millisecondsSinceEpoch);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedIndex == 0
          ? (data.schoolData.schoolColor != null ? data.schoolData.schoolColor : cacheData.schoolColor)
          : Theme.of(context).scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: selectedIndex == 0
            ? SystemUiOverlayStyle.light
            : Theme.of(context).backgroundColor == Colors.black
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
        child: Center(
            child: SafeArea(
                child: isLoading
                    ? CircularProgressIndicator(color: cacheData.schoolColor,)
                    : _childrenWidgets[selectedIndex]
                    )),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Theme.of(context).bottomAppBarColor,
          selectedItemBorderColor: Theme.of(context).bottomAppBarColor,
          selectedItemBackgroundColor: (data.schoolData.schoolColor != null ? data.schoolData.schoolColor : cacheData.schoolColor),
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
          FFNavigationBarItemv2(
            iconData: Icons.home_rounded,
            label: 'Domov',
          ),
          FFNavigationBarItemv2(
            iconData: Icons.fastfood,
            label: 'Malice',
          ),
          /* FFNavigationBarItemv2(
            iconData: Icons.person_search,
            label: 'P.O.',
          ), */
          FFNavigationBarItemv2(
            iconData: FluttereAIcon.ea,
            label: 'eAsistent',
          ),
          FFNavigationBarItemv2(
            iconData: Icons.calendar_today_rounded,
            label: 'Urnik',
          ),
          FFNavigationBarItemv2(
            iconData: Icons.settings,
            label: 'Nastavitve',
          ),
        ],
      ),
    );
  }
}
