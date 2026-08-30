import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/article.dart';

/// Panier d'achat persiste dans SharedPreferences.
/// Permet de selectionner plusieurs articles et de conserver la selection
/// meme en fermant l'application.
class Cart extends ChangeNotifier {
  Cart._();
  static final Cart instance = Cart._();

  static const String _storageKey = 'smart_room_cart_items_v1';
  final Map<String, Article> _items = {};

  List<Article> get items => _items.values.toList();
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get total => _items.values.fold(0, (sum, a) => sum + a.price);

  bool contains(String articleId) => _items.containsKey(articleId);

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_storageKey);
      if (list != null) {
        _items.clear();
        for (final str in list) {
          final map = jsonDecode(str) as Map<String, dynamic>;
          final article = Article.fromJson(map);
          _items[article.id] = article;
        }
        notifyListeners();
      }
    } catch (_) {
      // Ignore cache errors
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _items.values.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList(_storageKey, list);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  void toggle(Article article) {
    if (_items.containsKey(article.id)) {
      _items.remove(article.id);
    } else {
      _items[article.id] = article;
    }
    _save();
    notifyListeners();
  }

  void remove(String articleId) {
    _items.remove(articleId);
    _save();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _save();
    notifyListeners();
  }
}
