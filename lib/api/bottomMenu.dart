import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/icons/ea_icon.dart';
import 'package:scv_app/pages/Lockers/main.dart';
import 'package:scv_app/pages/Malice/main.dart';
import 'package:scv_app/pages/Nastavitve/main.dart';
import 'package:scv_app/pages/Urnik/main.dart';
import 'package:scv_app/pages/easistentPage.dart';
import 'package:scv_app/pages/schoolHomePage.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final bool settings;
  final Widget page;
  BottomMenuItem({
    required this.title,
    required this.icon,
    required this.page,
    required this.id,
    this.settings = false,
  });
}

class BottomMenu {
  static final List<BottomMenuItem> allItems = [
    BottomMenuItem(
        title: "Domov",
        icon: Icons.home_rounded,
        id: "home",
        page: SchoolHomePage()),
    BottomMenuItem(
        title: "Malice",
        icon: Icons.fastfood,
        id: "malice",
        page: MalicePage()),
    BottomMenuItem(
      title: "Urniki",
      icon: Icons.calendar_today_rounded,
      id: "urniki",
      page: UrnikPage(),
    ),
    BottomMenuItem(
        title: "eAsistent",
        icon: FluttereAIcon.ea,
        id: "easistent",
        page: EasistentPage()),
    BottomMenuItem(
        title: "Nastavitve",
        icon: Icons.settings,
        settings: true,
        id: "nastavitve",
        page: NastavitvePage()),
    BottomMenuItem(
        title: "Omarice",
        icon: Icons.shelves,
        id: "lockers",
        page: LockerPage()),
  ];

  List<BottomMenuItem> mainMenu = [];
  List<BottomMenuItem> moreMenu = [];
  List<Widget> pages = [];

  static final String storageKey = "com.scvapp.bottomMenu";

  Future<void> saveMainMenu(List<BottomMenuItem> mainMenu) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(storageKey, mainMenu.map((e) => e.id).join(","));
  }

  Future<List<String>> getFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(storageKey);
    if (json == null) {
      return ["home", "malice", "easistent", "urniki", "nastavitve"];
    }
    List<String> ids = json.split(",");
    if (ids.length < 2) {
      return ["home", "malice", "easistent", "urniki", "nastavitve"];
    }
    return ids;
  }

  Future<void> getMainMenuItems() async {
    List<String> ids = await this.getFromStorage();
    List<BottomMenuItem> items = [];
    List<Widget> pages = [];
    for (String id in ids) {
      BottomMenuItem? item = allItems.firstWhere((element) => element.id == id,
          orElse: () => BottomMenuItem(
              title: "N/A", icon: Icons.error, id: "error", page: Container()));
      items.add(item);
      pages.add(item.page);
    }
    this.mainMenu = items;
    if (this.mainMenu.length < 2) {
      this.mainMenu = allItems.sublist(0, 2);
      this.saveMainMenu(this.mainMenu);
    }
    this.pages = pages;
  }

  Future<void> getMoreMenuItems() async {
    List<String> ids = await this.getFromStorage();
    List<BottomMenuItem> items = [];
    for (BottomMenuItem item in allItems) {
      if (!ids.contains(item.id)) {
        items.add(item);
      }
    }
    this.moreMenu = items;
  }

  Future<void> changeMenu(BuildContext context, int oldIndex, int newIndex,
      int oldListIndex, int newListIndex) async {
    BottomMenuItem? item;
    if (oldListIndex == 0) {
      item = this.mainMenu.elementAt(oldIndex);
    } else {
      item = this.moreMenu.elementAt(oldIndex);
    }
    if (oldListIndex == 0 && newListIndex == 0) {
      this.mainMenu.removeAt(oldIndex);
      this.mainMenu.insert(newIndex, item);
    } else if (oldListIndex == 1 && newListIndex == 1) {
      this.moreMenu.removeAt(oldIndex);
      this.moreMenu.insert(newIndex, item);
    } else if (oldListIndex == 0 && newListIndex == 1) {
      if (item.settings == true) {
        return;
      }
      // Limits the number of main menu items to minimum 2
      if (this.mainMenu.length <= 2) {
        return;
      }

      this.mainMenu.removeAt(oldIndex);
      this.moreMenu.insert(newIndex, item);
    } else if (oldListIndex == 1 && newListIndex == 0) {
      if (item.settings == true) {
        return;
      }
      // Limits the number of main menu items to maximum 5
      if (this.mainMenu.length >= 5) {
        return;
      }

      this.moreMenu.removeAt(oldIndex);
      this.mainMenu.insert(newIndex, item);
    }

    // await this.saveMainMenu(this.mainMenu);
  }
}
