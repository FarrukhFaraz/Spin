import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceClass {
  Future<SharedPreferences> preference = SharedPreferences.getInstance();

  setData(bool value) async {
    final prefs = await preference;

    prefs.setBool('value', value);
  }

  getData() async {
    final prefs = await preference;
    var val = prefs.getBool('value');
    if (val == null) {
      return false;
    } else {
      if (val == true) {
        return true;
      } else {
        return false;
      }
    }
  }
}
