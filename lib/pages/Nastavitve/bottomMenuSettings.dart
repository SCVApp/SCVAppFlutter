import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:restart_app/restart_app.dart';
import 'package:scv_app/api/bottomMenu.dart';
import 'package:scv_app/components/confirmAlert.dart';
import 'package:scv_app/extension/hexColor.dart';
import 'package:scv_app/store/AppState.dart';

class BottomMenuSettings extends StatefulWidget {
  @override
  _BottomMenuSettingsState createState() => _BottomMenuSettingsState();
}

class _BottomMenuSettingsState extends State<BottomMenuSettings> {
  Future<void> loadMenuItems() async {
    BottomMenu bottomMenu =
        StoreProvider.of<AppState>(context, listen: false).state.bottomMenu;
    await Future.wait(
        [bottomMenu.getMainMenuItems(), bottomMenu.getMoreMenuItems()]);

    StoreProvider.of<AppState>(context, listen: false).dispatch(bottomMenu);
  }

  @override
  void initState() {
    super.initState();
    loadMenuItems();
  }

  void askToSave() {
    confirmAlert(
        context,
        "Želite shraniti spremembe? Če jih shranite, se bo aplikacija ponovno zagnala.",
        saveMainMenu,
        goBack);
  }

  void saveMainMenu() {
    BottomMenu bottomMenu =
        StoreProvider.of<AppState>(context, listen: false).state.bottomMenu;
    bottomMenu.saveMainMenu(bottomMenu.mainMenu);

    // restart the app
    Restart.restartApp(
      notificationTitle: 'Shranjeno',
      notificationBody: 'Kliknite, da odprete aplikacijo',
    );
  }

  void goBack() async {
    await loadMenuItems();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Nastavitve spodnjega menija"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: askToSave,
          ),
        ),
        body: StoreConnector<AppState, BottomMenu>(
            converter: (store) => store.state.bottomMenu,
            builder: (context, bottomMenu) {
              return DragAndDropLists(
                axis: Axis.vertical,
                listPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildDraggableList("Glavni menu", bottomMenu.mainMenu),
                  _buildDraggableList("Več", bottomMenu.moreMenu),
                ],
                onItemReorder: _onReorder,
                onListReorder: (oldIndex, newIndex) {}, // Not needed here
              );
            }));
  }

  DragAndDropList _buildDraggableList(
      String title, List<BottomMenuItem> items) {
    return DragAndDropList(
      canDrag: false,
      header: _sectionTitle(title),
      children: items.map((item) {
        return DragAndDropItem(
          child: _buildMenuItem(item),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BottomMenuItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(item.icon, color: HexColor.fromHex("#A6CE39")),
        ),
        title: Text(item.title),
        trailing: Icon(Icons.drag_handle, color: Colors.grey),
      ),
    );
  }

  void _onReorder(
      int oldIndex, int oldListIndex, int newIndex, int newListIndex) {
    BottomMenu bottomMenu =
        StoreProvider.of<AppState>(context, listen: false).state.bottomMenu;
    bottomMenu.changeMenu(
        context, oldIndex, newIndex, oldListIndex, newListIndex);

    StoreProvider.of<AppState>(context, listen: false).dispatch(bottomMenu);
  }
}
