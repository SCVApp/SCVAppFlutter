import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/data.dart';

import 'boxForHour.dart';

class HoursBoxUrnik extends StatefulWidget {
  HoursBoxUrnik(
      {Key key,
      this.isSmall = false,
      this.urnikBoxStyle,
      this.trajanjeUra,
      this.mainTitle = "",
      this.urnikData})
      : super(key: key);

  final bool isSmall;
  final UrnikBoxStyle urnikBoxStyle;
  final UraTrajanje trajanjeUra;
  final String mainTitle;
  final UrnikData urnikData;

  HoursBoxUrnikState createState() => HoursBoxUrnikState();
}

class HoursBoxUrnikState extends State<HoursBoxUrnik> {
  double izbranaUra = 0; // Katera ura jeizbrana v istem casovnem obdobju
  int steviloUrVCasovnemObdobju = 1;
  void spremeniIzbranoUro(int index) {
    setState(() {
      izbranaUra = index.toDouble();
    });
  }

  Widget scrollView(SomeValuseForSize someValuesForSize) {
    return Container(
        clipBehavior: Clip.none,
        height: someValuesForSize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          PageView(
            clipBehavior: Clip.none,
            onPageChanged: spremeniIzbranoUro,
            children: [
              for (int i = 0; i < steviloUrVCasovnemObdobju; i++) box()
            ],
          ),
          Positioned(
            child: steviloUrVCasovnemObdobju > 1
                ? DotsIndicator(
                    decorator: DotsDecorator(
                      activeColor: widget.urnikBoxStyle.primaryTextColor,
                      color: Colors.grey.withOpacity(0.4),
                      size:
                          !widget.isSmall ? Size.square(9.0) : Size.square(7.0),
                      activeSize:
                          !widget.isSmall ? Size.square(9.0) : Size.square(7.0),
                    ),
                    dotsCount: steviloUrVCasovnemObdobju,
                    position: izbranaUra,
                  )
                : SizedBox(),
          )
        ]));
  }

  Widget box() {
    return Padding(
      child: HourBoxUrnik(
        isSmall: widget.isSmall,
        urnikBoxStyle: widget.urnikBoxStyle,
        trajanjeUra: widget.trajanjeUra,
        context: context,
        mainTitle: widget.mainTitle,
        urnikData: widget.urnikData,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      final SomeValuseForSize someValuesForSize = !widget.isSmall
          ? SomeValuseForSize(
              height: 90,
              primaryFontSize: 24,
              secundaryFontSize: 15,
              widthOfIcon: 30)
          : SomeValuseForSize(
              height: 60,
              primaryFontSize: 20,
              secundaryFontSize: 13,
              widthOfIcon: 30);
      if (widget.trajanjeUra != null && widget.trajanjeUra.ura.length > 0) {
        steviloUrVCasovnemObdobju = widget.trajanjeUra.ura.length;
      }
      return this.scrollView(someValuesForSize);
    }));
  }
}
