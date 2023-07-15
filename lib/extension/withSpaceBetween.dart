import 'package:flutter/material.dart';

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double spacing = 20}) => [
        for (int i = 0; i < this.length; i++) ...[
          if (i > 0) Padding(padding: EdgeInsets.only(bottom: spacing)),
          this[i],
        ],
      ];
}
