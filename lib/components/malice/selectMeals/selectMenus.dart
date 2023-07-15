import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/malice/malicaMeni.dart';
import 'package:scv_app/components/malice/selectMeals/selectMenuBox.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

import '../../../api/malice/malica.dart';
import '../../../api/malice/malicaDan.dart';
import '../../../store/AppState.dart';

Widget MealSelectMenus(BuildContext context, int selectedDate) {
  return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        MalicaDan? dan = malica.getDay(selectedDate);
        List<MalicaMeni> meniji = dan?.meniji ?? [];
        MalicaMeni? selectedMeni = dan?.getSelectedMenu();
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            children: [
              for (MalicaMeni meni in meniji)
                MealSelectBox(context, dan, meni,
                    isSelected: selectedMeni?.id == meni.id),
              MealSelectBox(context, null, null,
                  isSelected: selectedMeni == null),
              Padding(padding: EdgeInsets.only(bottom: 40)),
            ].withSpaceBetween(spacing: 20),
          ),
        );
      });
}
