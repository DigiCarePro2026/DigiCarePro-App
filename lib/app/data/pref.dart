import 'package:shared_preferences/shared_preferences.dart';

class Pref {

  static Pref? _instance;

  static SharedPreferences? _prefs;

  static Pref get(){
    return _instance ??= Pref();
  }

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static setString(String key, String? value) {
    if(value == null){
      _prefs!.remove(key);
    }else {
      _prefs!.setString(key, value);
    }
  }

  static getString(String key) {
    return _prefs!.getString(key);
  }

  static getInt(String key) {
    return _prefs!.getInt(key);
  }

  static const theme = 'theme';
  static const token = 'token';
  static const profile = 'profile';
}
