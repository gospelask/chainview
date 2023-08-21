import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  late SharedPreferences _preferences;
  String _baseUrl = "http://mgt.zhnt-x.com/rtlly//mbuy/lst";
  bool _searchEnable = false;
  bool _navbarEnable = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("默认启动页面",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        TextButton(
                            onPressed: _showMyDialog,
                            child: Text("修改",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: MyColors.primary))),
                        SizedBox(height: 50)
                      ],
                    ),
                    Text(_baseUrl,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("首页搜索栏",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: _searchEnable,
                          onChanged: _changeSearchState,
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Text("是否显示首页的搜索栏",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("首页导航栏",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: _navbarEnable,
                          onChanged: _changeNavbarState,
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Text("是否显示首页的导航栏",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("版本号：v1.0.0",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[400])),
              ),
            ),
            Divider(height: 0),
            Container(height: 15),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
        ),
        title: Text("中惠农通市场广播设置"),
      ),
    );
  }

  Future<void> _loadData() async {
    _preferences = await SharedPreferences.getInstance();
    setState((){
      _baseUrl = _preferences.getString(AppPreferencesKey.BASE_URL) ?? _baseUrl;
      _searchEnable =
          _preferences.getBool(AppPreferencesKey.SEARCH_ENABLE) ?? _searchEnable;
      _navbarEnable =
          _preferences.getBool(AppPreferencesKey.NAVBAR_ENABLE) ?? _navbarEnable;
    });
  }

  void _changeBaseUrl(String baseUrl) async {
    setState(() {
      _baseUrl = baseUrl;
    });
    await _preferences.setString(AppPreferencesKey.BASE_URL, baseUrl);
  }

  void _changeSearchState(bool value) async {
    setState(() {
      _searchEnable = value;
    });
    await _preferences.setBool(AppPreferencesKey.SEARCH_ENABLE, value);
  }

  void _changeNavbarState(bool value) async {
    setState(() {
      _navbarEnable = value;
    });
    await _preferences.setBool(AppPreferencesKey.NAVBAR_ENABLE, value);
  }

  Future<void> _showMyDialog() async {
    final _urlController = TextEditingController();
    _urlController.text = _baseUrl;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改默认启动页面'),
          content: TextField(
            keyboardType: TextInputType.url,
            controller: _urlController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(onPressed: () {
              _changeBaseUrl(_urlController.text);
              Navigator.pop(context);
            }, child: const Text('确认')),
          ],
        );
      },
    );
  }

}
