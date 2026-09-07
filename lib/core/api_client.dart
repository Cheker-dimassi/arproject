import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';
import '../data/article.dart';
import '../data/quote_request.dart';

class ApiException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;
  ApiException(this.message, {this.fieldErrors});

  @override
  String toString() => message;
}

class ApiClient {
  static const String _articlesCacheKey = 'smart_room_articles_cache_v1';
  static List<Article> _memoryCache = [];

  static List<Article> get cachedArticles => List.unmodifiable(_memoryCache);

  /// Charge le cache depuis SharedPreferences au demarrage
  static Future<List<Article>> loadCache() async {
    if (_memoryCache.isNotEmpty) return _memoryCache;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_articlesCacheKey);
      if (jsonStr != null) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _memoryCache = list.map((item) => Article.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return _memoryCache;
  }

  /// Sauvegarde la liste d'articles dans SharedPreferences
  static Future<void> _saveCache(List<Article> articles) async {
    _memoryCache = articles;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(articles.map((a) => a.toJson()).toList());
      await prefs.setString(_articlesCacheKey, jsonStr);
    } catch (_) {}
  }

  static Future<List<Article>> fetchArticles({
    String? category,
    bool? featured,
    int size = 50,
  }) async {
    final params = <String, String>{'size': '$size'};
    if (category != null) params['category'] = category;
    if (featured != null) params['featured'] = '$featured';

    final uri = Uri.parse(AppConfig.articlesEndpoint).replace(queryParameters: params);
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      _throwIfError(response);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final content = body['content'] as List<dynamic>;
      final articles = content.map((item) => Article.fromJson(item as Map<String, dynamic>)).toList();

      // Mettre en cache uniquement si pas de filtre specifique
      if (category == null && featured == null && articles.isNotEmpty) {
        await _saveCache(articles);
      }
      return articles;
    } catch (e) {
      // En cas de panne reseau ou serveur eteint, charger depuis le cache hors-ligne
      final cached = await loadCache();
      if (cached.isNotEmpty) {
        var filtered = cached;
        if (category != null) {
          filtered = filtered.where((a) => a.category.toLowerCase() == category.toLowerCase()).toList();
        }
        if (featured != null && featured) {
          filtered = filtered.where((a) => a.featured).toList();
        }
        return filtered;
      }
      if (e is ApiException) rethrow;
      throw ApiException(
        'Impossible de joindre le serveur et aucun cache hors-ligne disponible.',
      );
    }
  }

  static Future<Article> fetchArticleById(String id) async {
    // Verifier d'abord le cache
    for (final a in _memoryCache) {
      if (a.id == id) return a;
    }
    final cached = await loadCache();
    for (final a in cached) {
      if (a.id == id) return a;
    }

    final uri = Uri.parse('${AppConfig.articlesEndpoint}/$id');
    final response = await http.get(uri);
    _throwIfError(response);
    return Article.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  static Future<SubmittedQuote> submitQuote(QuoteRequestPayload payload) async {
    final response = await http.post(
      Uri.parse(AppConfig.quotesEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload.toJson()),
    );
    _throwIfError(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SubmittedQuote.fromJson(json);
  }

  /// Consulte le statut en direct d'un devis donne
  static Future<SubmittedQuote> fetchQuote(int id) async {
    final response = await http.get(
      Uri.parse('/'),
    );
    _throwIfError(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SubmittedQuote.fromJson(json);
  }

  static Future<List<SubmittedQuote>> fetchAllQuotesAdmin({
    required String username,
    required String password,
  }) async {
    final auth = 'Basic ${base64Encode(utf8.encode("$username:$password"))}';
    final response = await http.get(
      Uri.parse(AppConfig.quotesEndpoint),
      headers: {'Authorization': auth},
    );
    _throwIfError(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => SubmittedQuote.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<SubmittedQuote> updateQuoteStatusAdmin({
    required int id,
    required String status,
    required String username,
    required String password,
  }) async {
    final auth = 'Basic ${base64Encode(utf8.encode("$username:$password"))}';
    final response = await http.patch(
      Uri.parse('${AppConfig.quotesEndpoint}/$id/status'),
      headers: {
        'Authorization': auth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );
    _throwIfError(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SubmittedQuote.fromJson(json);
  }

  static void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message = body['message'] as String? ?? 'Une erreur est survenue.';
      final rawFields = body['fields'] as Map<String, dynamic>?;
      final fields = rawFields?.map((key, value) => MapEntry(key, value.toString()));
      throw ApiException(message, fieldErrors: fields);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Le serveur a repondu avec une erreur (${response.statusCode}). '
        'Verifie que le backend tourne et que l\'IP dans app_config.dart est correcte.',
      );
    }
  }
}
