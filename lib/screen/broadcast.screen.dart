import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/share_pref.dart';
import '../provider/global_notifier.dart';

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

  late TextEditingController _urlController;

  double progress = 0;
  String _baseUrl = "";
  bool _searchEnable = false;
  bool _navbarEnable = false;
  late String _date;
  late String _week;
  late String _time;
  Timer? _timer;
  String pageTitle = "万载百合商业广场";
  int _reloadTime = 0;
  int _reloadWaitTime = 30;
  bool _loading = false;

  late FocusNode _settingFocusNode;

  @override
  void initState() {
    super.initState();
    _formatDateTime();
    _urlController = TextEditingController();
    _settingFocusNode = FocusNode();
    _loadData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_urlController.text=="zhnt://error" && !_loading) {
        if (_reloadTime >= _reloadWaitTime) {
          _reloadTime = 0;
          _loading = true;
          _loadUrl(_baseUrl);
        } else {
          _reloadTime++;
        }
      }
      _formatDateTime();
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _urlController.dispose();
    _settingFocusNode.dispose();
    super.dispose();
  }

  void _formatDateTime() {
    DateTime dateTime = DateTime.now();
    _date = "${dateTime.year}/${dateTime.month}/${dateTime.day}";
    final weeks = <String>['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    _week = weeks[dateTime.weekday - 1];
    _time = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

  Future<void> _loadUrl(String value) async {
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

  Future<void> _loadData() async {
    _baseUrl = (await SharedPref.getBaseUrl()) ?? _baseUrl;
    _searchEnable = (await SharedPref.getSearchEnable()) ?? _searchEnable;
    _navbarEnable = (await SharedPref.getNavbarEnable()) ?? _navbarEnable;
    _checkUrl();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          print(event.logicalKey);
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              _settingFocusNode.requestFocus();
            } else if (event.logicalKey == LogicalKeyboardKey.tvContentsMenu ||
                event.logicalKey == LogicalKeyboardKey.contextMenu) {
              Navigator.pushNamed(context, "/settings");
            }
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
                              focusNode: _settingFocusNode,
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
                  Consumer<GlobalNotifier>(builder: (_, globalNotifier, child) {
                    return InAppWebView(
                      key: webViewKey,
                      // initialUrlRequest: URLRequest(url: Uri.parse(_baseUrl)),
                      // initialFile: "assets/404.html",
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: options,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                        if (globalNotifier.needClean) {
                          webViewController?.clearCache();
                        }
                        _checkUrl();
                      },
                      onLoadStart: (controller, url) {
                        _loading = true;
                        setState(() {
                          _urlController.text = url.toString();
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
                        _loading = false;
                        _urlController.text = url.toString();
                        String? title = await controller.getTitle();
                        this.pageTitle = title != null ? title : "";
                        if (["file"].contains(url!.scheme) &&
                            url.toString().endsWith("assets/error.html")) {
                          _urlController.text = "zhnt://error";
                        }
                        setState(() {});
                      },
                      onLoadError: (controller, url, code, message) async {
                        url = (url ?? 'about:blank') as Uri?;
                        webViewController?.loadFile(
                            assetFilePath: "assets/error.html");
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {}
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          _urlController.text = url.toString();
                        });
                      },
                    );
                  }),
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
