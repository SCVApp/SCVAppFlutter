import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/components/urnik/viewForUre.dart';
import 'package:scv_app/pages/Urnik/style.dart';

class ViewForObdobjeUre extends StatefulWidget {
  final ViewSizes viewSizes;
  final ObdobjaUr? obdobjeUr;
  ViewForObdobjeUre(
      {Key? key, this.obdobjeUr, required this.viewSizes})
      : super(key: key);

  @override
  _viewForObdobjeUreState createState() => _viewForObdobjeUreState();
}

class _viewForObdobjeUreState extends State<ViewForObdobjeUre> {
  int izbranaUra = 0;

  void changeIzbranaUra(int index) {
    setState(() {
      izbranaUra = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.obdobjeUr != null
        ? Container(
            clipBehavior: Clip.none,
            height: widget.viewSizes.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                viewForUre(widget.obdobjeUr!, changeIzbranaUra, widget.viewSizes,
                    context),
                Positioned(
                  child: widget.obdobjeUr!.ure.length > 1
                      ? DotsIndicator(
                          decorator: DotsDecorator(
                            activeColor: UrnikStyle.colorForUraViewText(
                                widget.obdobjeUr!.ure[izbranaUra].type, context),
                            color: Colors.grey.withOpacity(0.4),
                            size: widget.viewSizes.sizeOfDots,
                            activeSize: widget.viewSizes.sizeOfDots,
                          ),
                          dotsCount: widget.obdobjeUr!.ure.length,
                          position: izbranaUra.toDouble(),
                        )
                      : SizedBox(),
                )
              ],
            ),
          )
        : loadingItem(Colors.blue);
  }
}
