/// Point unique de configuration de l'app.
///
/// Pendant le dev local, remplace par l'IP de ta machine sur le meme
/// reseau Wi-Fi que ton telephone. `localhost` ne fonctionne PAS depuis
/// un appareil physique.
class AppConfig {
  static const String apiBaseUrl = 'http://127.0.0.1:8080';

  static const String articlesEndpoint = '$apiBaseUrl/api/articles';
  static const String quotesEndpoint = '$apiBaseUrl/api/quotes';
}
