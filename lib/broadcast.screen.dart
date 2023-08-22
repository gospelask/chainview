import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class BroadcastScreen extends StatefulWidget {
  @override
  _BroadcastScreenState createState() => new _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  final _urlController = TextEditingController();
  String _url = '';
  String _baseUrl = "";
  bool _searchEnable = false;
  bool _navbarEnable = false;
  late String _date;
  late String _week;
  late String _time;
  Timer? _timer;
  String pageTitle = "万载百合商业广场";

  FocusNode _settingFoucsNode = FocusNode();

  void _formatDateTime() {
    DateTime dateTime = DateTime.now();
    _date = "${dateTime.year}/${dateTime.month}/${dateTime.day}";
    final weeks = <String>['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    _week = weeks[dateTime.weekday - 1];
    _time = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

  void _loadUrl(String value) {
    if (value.isNotEmpty) {
      var url = Uri.parse(value);
      if (url.scheme.isEmpty) {
        url = Uri.parse("https://www.baidu.com/s?wd=" + value);
      }
      webViewController?.loadUrl(urlRequest: URLRequest(url: url));
    }
  }

  void _checkUrl() async {
    if (_baseUrl.toLowerCase() !=
        (await webViewController?.getUrl()).toString().toLowerCase()) {
      _loadUrl(_baseUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _formatDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(_formatDateTime);
    });
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      _baseUrl = _preferences.getString(AppPreferencesKey.BASE_URL) ?? _baseUrl;
      _searchEnable = _preferences.getBool(AppPreferencesKey.SEARCH_ENABLE) ??
          _searchEnable;
      _navbarEnable = _preferences.getBool(AppPreferencesKey.NAVBAR_ENABLE) ??
          _navbarEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          print(event.logicalKey);
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                event.logicalKey == LogicalKeyboardKey.arrowUp ||
                event.logicalKey == LogicalKeyboardKey.arrowRight ||
                event.logicalKey == LogicalKeyboardKey.arrowDown)
              _settingFoucsNode.requestFocus();
          }
        },
        child: Scaffold(
          body: SafeArea(
              child: Column(children: <Widget>[
            Container(
              height: 35,
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Image(
                                width: 22,
                                height: 22,
                                image: AssetImage(
                                    "assets/images/ic_launcher_round.webp")),
                            Text(
                              pageTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                  DefaultTextStyle(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            _date,
                          ),
                          Text(_week),
                          Text(_time),
                          Material(
                            color: Colors.white.withAlpha(20),
                            child: InkWell(
                              focusColor: Colors.green.withAlpha(100),
                              focusNode: _settingFoucsNode,
                              onTap: () =>
                                  Navigator.pushNamed(context, "/settings"),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.settings,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            if (_searchEnable)
              TextField(
                decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                controller: _urlController,
                keyboardType: TextInputType.url,
                onSubmitted: (value) {
                  _loadUrl(value);
                },
              )
            else
              Container(),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: Uri.parse(_baseUrl)),
                    // initialFile: "assets/index.html",
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                      _checkUrl();
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this._url = url.toString();
                        _urlController.text = this._url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          // Launch the App
                          await launchUrl(
                            uri,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() async {
                        this._url = url.toString();
                        _urlController.text = this._url;
                        String? title = await controller.getTitle();
                        this.pageTitle = title != null ? title : "";
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this._url = url.toString();
                        _urlController.text = this._url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                ],
              ),
            ),
            if (_navbarEnable)
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: () {
                      webViewController?.goBack();
                    },
                  ),
                  ElevatedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      webViewController?.goForward();
                    },
                  ),
                  ElevatedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      webViewController?.reload();
                    },
                  ),
                ],
              )
            else
              Container(),
          ])),
        ));
  }
}
