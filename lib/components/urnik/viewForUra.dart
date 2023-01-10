import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/ura.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget viewForUra(
    ObdobjaUr obdobjeUre, Ura ura, ViewSizes viewSizes, BuildContext context) {
  return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return Container(
            height: viewSizes.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: obdobjeUre.type == ObdobjaUrType.normalno
                  ? UrnikStyle.colorForUraViewBG(ura.type, context)
                  : obdobjeUre.type == ObdobjaUrType.trenutno
                      ? user.school.schoolColor
                      : user.school.schoolSecondaryColor,
            ),
            child: Stack(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            "${obdobjeUre.id}.${obdobjeUre.id < 10 ? " " : ""}",
                            style: TextStyle(
                                fontSize: viewSizes.primaryFontSize,
                                color: UrnikStyle.colorForUraViewText(
                                    ura.type, context)),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  child: Text(
                                    "${ura.type == UraType.dogodek ? ura.dogodek : ura.krajsava}",
                                    style: TextStyle(
                                        fontSize: viewSizes.secundaryFontSize,
                                        color: UrnikStyle.colorForUraViewText(
                                            ura.type, context),
                                        overflow: TextOverflow.ellipsis,
                                        decoration: ura.type == UraType.odpadlo
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                                    maxLines: 1,
                                    softWrap: false,
                                    textAlign: TextAlign.left,
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  child: Text(
                                    "${obdobjeUre.trajanje}${ura.shortenTeacherName()}",
                                    style: TextStyle(
                                      fontSize: viewSizes.secundaryFontSize,
                                      color: UrnikStyle.colorForUraViewText(
                                          ura.type, context),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    ura.type != UraType.odpadlo
                        ? Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              ura.ucilnica,
                              style: TextStyle(
                                  fontSize: viewSizes.primaryFontSize,
                                  color: UrnikStyle.colorForUraViewText(
                                      ura.type, context),
                                  decoration: ura.type == UraType.odpadlo
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                              textAlign: TextAlign.right,
                            ),
                          )
                        : SizedBox()
                  ]),
              Positioned(
                child: ura.type != UraType.normalno
                    ? Image.asset(
                        UrnikStyle.pathToIcon(ura.type),
                        width: viewSizes.widthOfIcon,
                        height: viewSizes.widthOfIcon,
                      )
                    : SizedBox(),
                right: 2,
                top: 2,
              ),
            ]));
      });
}
