import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageSize / 2),
                    child: Image(
                      image: user != null
                          ? user.image
                          : AssetImage("assets/images/profilePicture.png"),
                      height: imageSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: user != null
                        ? Image(
                            image: user.status.assetImage ??
                                AssetImage(
                                    "assets/images/statusIcons/Unknown.png"),
                            height: imageSize / 3.75,
                          )
                        : CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ));
}
