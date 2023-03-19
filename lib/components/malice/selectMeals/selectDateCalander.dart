import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget MealsSelectDateCalander(BuildContext context) {
  return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return SfDateRangePicker(
          view: DateRangePickerView.month,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectionColor: user.school.schoolColor,
          todayHighlightColor: user.school.schoolColor,
          monthViewSettings: DateRangePickerMonthViewSettings(
              firstDayOfWeek: 1,
              weekendDays: [6, 7],
              numberOfWeeksInView: 6,
              showTrailingAndLeadingDates: true),
          allowViewNavigation: false,
          showNavigationArrow: true,
          enablePastDates: false,
        );
      });
}
