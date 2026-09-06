import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

/// Session administrateur pour le commercant / gestionnaire de boutique.
class AdminSession extends ChangeNotifier {
  AdminSession._();
  static final AdminSession instance = AdminSession._();

  static const String _userKey = 'smart_room_admin_user';
  static const String _passKey = 'smart_room_admin_pass';

  String? _username;
  String? _password;

  bool get isLoggedIn => _username != null && _password != null;
  String get username => _username ?? '';
  String get password => _password ?? '';

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString(_userKey);
      _password = prefs.getString(_passKey);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> login(String user, String pass) async {
    try {
      // Verifier les identifiants aupres du backend
      await ApiClient.fetchAllQuotesAdmin(username: user, password: pass);
      _username = user;
      _password = pass;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, user);
      await prefs.setString(_passKey, pass);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _username = null;
    _password = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_passKey);
    } catch (_) {}
    notifyListeners();
  }
}
