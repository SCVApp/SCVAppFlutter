import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  @override
  void initState() {
    super.initState();
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
        setState(() {
          webViewLoaded = true;
        });
      },
    );
  }

  Future<void> loadData() async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    await malica.maliceUser.load();
    StoreProvider.of<AppState>(context).dispatch(malica);
    if (malica.maliceUser.isLoggedIn() == true) {
      setState(() {
        isLoaded = true;
      });
      loadSiteMalica(malica.maliceUser);
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
    loadSiteMalica(malica.maliceUser);
  }

  void loadSiteMalica(MalicaUser malicaUser) {
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
