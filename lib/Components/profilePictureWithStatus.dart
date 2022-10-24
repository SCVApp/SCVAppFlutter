import 'package:flutter/material.dart';
import '../Data/data.dart';

Widget profilePictureWithStatus(Data data, BuildContext context) {
  double imageSize = MediaQuery.of(context).size.width / 3.1 > 120
      ? 120
      : MediaQuery.of(context).size.width / 3.1;

  if (data == null) {
    return Center(child: CircularProgressIndicator());
  }

  return Container(
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
              image: data != null
                  ? data.user.image
                  : AssetImage("assets/profilePicture.png"),
              height: imageSize,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: data != null
                ? Image(
                    image: data.user.status.assetImage ??
                        AssetImage("assets/statusIcons/Unknown.png"),
                    height: imageSize / 3.75,
                  )
                : CircularProgressIndicator(),
          ),
        )
      ],
    ),
  );
}
