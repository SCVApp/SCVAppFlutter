import 'package:flutter/material.dart';

class MaliceLoginPage extends StatefulWidget {
  @override
  _MaliceLoginPageState createState() => _MaliceLoginPageState();
}

class _MaliceLoginPageState extends State<MaliceLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AutofillGroup(
                child: Column(
              children: [
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                      autocorrect: false,
                      autofillHints: [AutofillHints.email],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'E-pošta',
                          hintText:
                              'E-poštni naslov v obliki ime.priimek@scv.si')),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 20),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    obscureText: true,
                    autocorrect: false,
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(),
                        labelText: 'Geslo',
                        hintText: 'Geslo za dostop do sistema malic'),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
