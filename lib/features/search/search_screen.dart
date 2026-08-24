import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../article_detail/article_detail_screen.dart';
import '../catalog/widgets/article_card.dart';
import '../../widgets/state_message.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Article> _all = [];
  List<Article> _results = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final articles = await ApiClient.fetchArticles();
      setState(() {
        _all = articles;
        _results = articles;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  void _onQueryChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _results = q.isEmpty
          ? _all
          : _all.where((a) =>
              a.name.toLowerCase().contains(q) ||
              a.category.toLowerCase().contains(q) ||
              a.material.toLowerCase().contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.search, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              onChanged: _onQueryChanged,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: s.searchHint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                  : _error != null
                      ? StateMessage(
                          icon: Icons.wifi_off,
                          title: s.loadError,
                          subtitle: _error!,
                          onRetry: _load,
                        )
                      : _results.isEmpty
                          ? StateMessage(
                              icon: Icons.search_off,
                              title: s.noResults,
                              subtitle: s.noResultsSubtitle,
                              onRetry: null,
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.68,
                              ),
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final article = _results[index];
                                return ArticleCard(
                                  article: article,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ArticleDetailScreen(article: article)),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
