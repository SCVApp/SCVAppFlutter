import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:scv_app/data.dart';
import 'package:scv_app/domov.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:scv_app/main.dart';
import 'package:scv_app/prijava.dart';

class OnBoardingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    void goToHome() async {
    UserData user = await signInUser();
    if(user != null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: "SCVApp",)));
    }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        elevation: 0,
      ),
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Dobrodošel/a na aplikaciji ŠCVApp!',
              body: '',
              image: buildImage('assets/school_logo.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Vsa orodja na enem mestu.',
              body: 'Vsa orodja, potrebna za šolanje na enem mestu.',
              image: buildImage('assets/orodja.png'),
              decoration: getPageDecoration(),
            ),
            // PageViewModel(
            //   title: 'Simple UI',
            //   body: 'For enhanced reading experience',
            //   // image: buildImage('assets/manthumbs.png'),
            //   decoration: getPageDecoration(),
            // ),
            PageViewModel(
              title: 'Preprosto. Varno.',
              body:
                  'Prijavi se z šolskim računom in dostopaj do vseh funkcij ŠCVAppa!',
              image: buildImage('assets/microsoft.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Prijava', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(),
          showSkipButton: true,
          skip: Text('Preskoči'),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          // globalBackgroundColor: Theme.of(context).primaryColor,
          skipFlex: 0,
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
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Color.fromARGB(255, 236, 236, 236),
      );
}
