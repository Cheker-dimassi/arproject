import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/article.dart';

class Favorites extends ChangeNotifier {
  Favorites._();
  static final Favorites instance = Favorites._();

  static const _key = 'favorites_ids';

  final Set<String> _ids = {};
  final List<Article> _articles = [];

  List<Article> get items => List.unmodifiable(_articles);
  int get count => _ids.length;
  bool contains(String id) => _ids.contains(id);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    _ids.addAll(saved);
    notifyListeners();
  }

  Future<void> toggle(Article article) async {
    if (_ids.contains(article.id)) {
      _ids.remove(article.id);
      _articles.removeWhere((a) => a.id == article.id);
    } else {
      _ids.add(article.id);
      _articles.add(article);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }

  void syncWithCatalog(List<Article> catalog) {
    _articles.clear();
    _articles.addAll(catalog.where((a) => _ids.contains(a.id)));
    notifyListeners();
  }
}
