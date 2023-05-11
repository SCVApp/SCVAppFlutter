import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:scv_app/components/alertContainer.dart';
import '../../api/user.dart';
import '../../extension/hexColor.dart';
import '../../store/AppState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void goToHome() async {
      final User user = StoreProvider.of<AppState>(context).state.user;
      user.logingIn = true;
      StoreProvider.of<AppState>(context).dispatch(user);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      bottomSheet: AlertContainer(),
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: AppLocalizations.of(context).welcome,
              body: '',
              image: buildImage(Theme.of(context).primaryColor == Colors.black
                  ? 'assets/images/school_logo.png'
                  : 'assets/images/school_logo_dark.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Vsa orodja na enem mestu.',
              body: 'Dijakom koristna orodja, zbrana na enem mestu.',
              image: buildImage('assets/images/orodja.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Preprosto in varno',
              body:
                  'Za dostop do vseh funkcij aplikacije ŠCVApp se prijavi s šolskim računom.',
              image: buildImage('assets/images/microsoft.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Prijava', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(),
          showSkipButton: true,
          skip: Text('Preskoči'),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          skipOrBackFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      ),
    );
  }

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        bodyPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Get.isDarkMode
            ? HexColor.fromHex("#121212")
            : Color.fromARGB(255, 236, 236, 236),
      );
}
