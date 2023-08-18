import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
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
                        Text("修改",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: MyColors.primary)),
                        SizedBox(height: 50)
                      ],
                    ),
                    Text("http://mgt.zhnt-x.com/rtlly//mbuy/lst",
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
                          value: true,
                          onChanged: (value) {},
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
                          value: true,
                          onChanged: (value) {
                            setState(() {});
                          },
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
}

class MyColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);

  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
}
