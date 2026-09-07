import 'api_client.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/quote_request.dart';

/// Gestionnaire de l'historique des devis envoyes par l'utilisateur.
/// Persiste les devis crees dans SharedPreferences pour consultation ulterieure.
class QuoteHistory extends ChangeNotifier {
  QuoteHistory._();
  static final QuoteHistory instance = QuoteHistory._();

  static const String _storageKey = 'smart_room_user_quotes_v1';
  final List<SubmittedQuote> _quotes = [];

  List<SubmittedQuote> get quotes => List.unmodifiable(_quotes);
  int get count => _quotes.length;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey);
      if (rawList != null) {
        _quotes.clear();
        for (final item in rawList) {
          final map = jsonDecode(item) as Map<String, dynamic>;
          _quotes.add(SubmittedQuote.fromJson(map));
        }
        notifyListeners();
      }
    } catch (_) {
      // Ignore cache load errors
    }
  }

  Future<void> addQuote(SubmittedQuote quote) async {
    _quotes.removeWhere((q) => q.id == quote.id);
    _quotes.insert(0, quote);
    await _save();
    notifyListeners();
  }

  /// Interroge le serveur pour synchroniser le statut de chaque devis
  Future<void> refreshQuotes() async {
    bool changed = false;
    for (int i = 0; i < _quotes.length; i++) {
      try {
        final updated = await ApiClient.fetchQuote(_quotes[i].id);
        if (updated.status != _quotes[i].status) {
          _quotes[i] = updated;
          changed = true;
        }
      } catch (_) {
        // En cas d'erreur reseau, on conserve la version locale
      }
    }
    if (changed) {
      await _save();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _quotes.map((q) => jsonEncode(q.toJson())).toList();
      await prefs.setStringList(_storageKey, list);
    } catch (_) {
      // Ignore persistence errors
    }
  }
}
