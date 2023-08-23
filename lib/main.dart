import 'dart:async';
import 'dart:io';

import 'package:chain_edge/provider/global_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:chain_edge/screen/broadcast.screen.dart';
import 'package:chain_edge/screen/settings.screen.dart';
import 'package:provider/provider.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// InAppLocalhostServer localhostServer = new InAppLocalhostServer(documentRoot: 'assets');

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GlobalNotifier())],
      child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            theme: ThemeData(primarySwatch: Colors.green),
            initialRoute: "/",
            routes: {
              "/": (context) => BroadcastScreen(),
              "/settings": (context) => SettingsScreen()
            },
          )),
    );
  }
}
