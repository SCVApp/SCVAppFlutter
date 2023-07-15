import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/store/AppState.dart';

Widget ProfilePictureWithStatus(BuildContext context) {
  double imageSize = MediaQuery.of(context).size.width / 3.1 > 120
      ? 120
      : MediaQuery.of(context).size.width / 3.1;

  return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) => Container(
            width: imageSize,
            height: imageSize,
            constraints: BoxConstraints(
              maxHeight: 120,
              maxWidth: 120,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: !user.loadingFromWeb
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(imageSize / 2),
                          child: Image(
                            image: user.image ??
                                AssetImage(
                                        "assets/images/profile_placeholder.png")
                                    as ImageProvider,
                            height: imageSize,
                          ),
                        )
                      : loadingItem(user.school.schoolColor),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: !user.loadingFromWeb
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: user != null
                              ? Image(
                                  image: user.status.assetImage ??
                                      AssetImage(
                                          "assets/images/statusIcons/Unknown.png"),
                                  height: imageSize / 3.75,
                                )
                              : CircularProgressIndicator(),
                        )
                      : SizedBox(),
                )
              ],
            ),
          ));
}
