import 'package:flutter/material.dart';

Widget EPASAdminHomeTitle(BuildContext context, Function goBack){
  return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(
                  onPressed: goBack,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "VODJA",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Delavnice: Slovenija",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        )
                      ])
                ]),
              ],
            );
}