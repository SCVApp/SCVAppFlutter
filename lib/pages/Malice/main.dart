import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/EventTracking.dart';
import 'package:scv_app/api/malice/malicaUser.dart';
import 'package:scv_app/api/webview.dart';
import 'package:scv_app/pages/loading.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../api/malice/malica.dart';

class MalicePage extends StatefulWidget {
  @override
  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  late final WebViewController _controller = getWebViewController();
  bool isLoaded = false;
  bool webViewLoaded = false;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    EventTracking.trackScreenView("malicePage", "MalicePage");
    WidgetsBinding.instance.addPostFrameCallback((_) => onStateBuild());
  }

  void onStateBuild() async {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(getNavigationDelegate());
    await loadData();
  }

  NavigationDelegate getNavigationDelegate() {
    return NavigationDelegate(
      onPageFinished: (url) {
        if (!mounted) return;
        if (firstLoad == true) {
          loadSiteAfterLogin();
        }
        if (firstLoad == false) {
          setState(() {
            webViewLoaded = true;
          });
        } else {
          setState(() {
            firstLoad = false;
            webViewLoaded = true;
          });
        }
      },
    );
  }

  Future<void> loadData() async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    await malica.maliceUser.load();
    StoreProvider.of<AppState>(context).dispatch(malica);
    if (malica.maliceUser.enabled == false) {
      setState(() {
        isLoaded = true;
      });
      _controller..loadRequest(Uri.parse('https://malice.scv.si/'));
      return;
    }
    if (malica.maliceUser.isLoggedIn() == true) {
      setState(() {
        isLoaded = true;
      });
      loadSiteMalica(malica.maliceUser, malica);
      return;
    }
    await tryMicrosoftLogin();
  }

  Future<void> tryMicrosoftLogin() async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    await malica.maliceUser.loginWithMicrosoftToken();
    StoreProvider.of<AppState>(context).dispatch(malica);
    setState(() {
      isLoaded = true;
    });
    loadSiteMalica(malica.maliceUser, malica);
  }

  void loadSiteAfterLogin() {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    if (malica.afterLoginURL != null) {
      _controller..loadRequest(Uri.parse(malica.afterLoginURL!));
      malica.resetAfterLoginURL();
      StoreProvider.of<AppState>(context).dispatch(malica);
    }
  }

  void loadSiteMalica(MalicaUser malicaUser, Malica malica) {
    bool loggedIn = malicaUser.isLoggedIn();
    if (loggedIn) {
      _controller
        ..loadRequest(Uri.parse('https://malice.scv.si/api/v2/auth/api_login'),
            headers: {'Authorization': 'Bearer ${malicaUser.accessToken}'});
    } else {
      _controller..loadRequest(Uri.parse('https://malice.scv.si/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: !isLoaded
                ? LoadingPage()
                : Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      if (webViewLoaded == false)
                        Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                    ],
                  ));
      },
    );
  }
}
