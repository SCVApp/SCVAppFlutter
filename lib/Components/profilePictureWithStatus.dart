import 'package:flutter/material.dart';
import '../data.dart';

Widget profilePictureWithStatus(Data data){
  return Container(
                width: 120,
                height: 120,
                child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image(
                          image: data.user != null ? data.user.image : AssetImage("assets/profilePicture.png"),
                          height: 120,
                        ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(
                          image: data.user != null ? data.user.status.assetImage:AssetImage("assets/statusIcons/Unknown.png"),
                          height: 32,
                        ),
                  ),
                  )
                ],
              ),
              );
}