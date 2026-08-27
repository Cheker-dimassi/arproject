import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../../widgets/state_message.dart';
import '../article_detail/article_detail_screen.dart';

class ArPickerScreen extends StatefulWidget {
  const ArPickerScreen({super.key});

  @override
  State<ArPickerScreen> createState() => _ArPickerScreenState();
}

class _ArPickerScreenState extends State<ArPickerScreen> {
  late Future<List<Article>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiClient.fetchArticles();
  }

  void _retry() => setState(() => _future = ApiClient.fetchArticles());

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.chooseArArticle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              s.chooseArSubtitle,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.gold));
                  }
                  if (snapshot.hasError) {
                    return StateMessage(
                      icon: Icons.wifi_off,
                      title: s.loadError,
                      subtitle: '${snapshot.error}',
                      onRetry: _retry,
                    );
                  }
                  final articles = snapshot.data ?? [];
                  if (articles.isEmpty) {
                    return StateMessage(
                      icon: Icons.inbox_outlined,
                      title: s.noArticlesAvailable,
                      subtitle: s.emptyCatalogSubtitle,
                      onRetry: _retry,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _ArRow(article: articles[index]),
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

class _ArRow extends StatelessWidget {
  final Article article;
  const _ArRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    final image = article.displayImage;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(article: article),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: image != null
                      ? Image.network(image, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _Placeholder(article: article))
                      : _Placeholder(article: article),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      article.category,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          article.isWallMounted
                              ? Icons.push_pin_outlined
                              : Icons.crop_square_outlined,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.isWallMounted ? s.wall : s.floor,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.view_in_ar, size: 14, color: Color(0xFF14150F)),
                    SizedBox(width: 4),
                    Text('AR',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14150F))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Article article;
  const _Placeholder({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: article.accentColorValue.withValues(alpha: 0.18),
      child: Center(
        child: Icon(article.iconData,
            color: article.accentColorValue, size: 28),
      ),
    );
  }
}
