import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const BASE_URL = "baseUrl";
  static const SEARCH_ENABLE = "searchEnable";
  static const NAVBAR_ENABLE = "navbarEnable";

  static setBaseUrl(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(BASE_URL, value);
  }

  static Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BASE_URL) ?? null;
  }

  static setSearchEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SEARCH_ENABLE, value);
  }

  static Future<bool?> getSearchEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SEARCH_ENABLE) ?? null;
  }

  static setNavbarEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NAVBAR_ENABLE, value);
  }

  static Future<bool?> getNavbarEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(NAVBAR_ENABLE) ?? null;
  }
}
