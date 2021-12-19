import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUsernameKey = "USERNAMEKEY";
  static String sharedPreferenceEmailKey = "EMAILKEY";
  static String sharedPreferenceUserIdKey = "USERIDKEY";
  
  static Future<bool> saveUserLoggedInSharedPreference(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future<bool> saveUsernameSharedPreference(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernameKey, username);
  }

  static Future<bool> saveEmailSharedPreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceEmailKey, email);
  }

  static Future<bool> saveUserIdSharedPreference(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserIdKey, userId);
  }

  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUsernameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUsernameKey);
  }

  static Future<String?> getEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceEmailKey);
  }

  static Future<String?> getUserIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserIdKey);
  }
}
