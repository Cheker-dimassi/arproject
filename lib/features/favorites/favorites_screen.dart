import 'package:flutter/material.dart';
import '../../core/favorites.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../../widgets/state_message.dart';
import '../article_detail/article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final s = AppL10n.s;

    return Scaffold(
      appBar: canPop ? AppBar(title: Text(s.favorites)) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!canPop) ...[
                Text(s.favorites, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: ListenableBuilder(
                  listenable: Favorites.instance,
                  builder: (context, _) {
                    final items = Favorites.instance.items;
                    if (items.isEmpty) {
                      return StateMessage(
                        icon: Icons.favorite_border,
                        title: s.noFavorites,
                        subtitle: s.noFavoritesSubtitle,
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _FavRow(article: items[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavRow extends StatelessWidget {
  final Article article;
  const _FavRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final image = article.displayImage;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64, height: 64,
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
                    Text(article.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    const SizedBox(height: 3),
                    Text(article.category,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('${article.price.toStringAsFixed(0)} DT',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: AppColors.gold, size: 22),
                onPressed: () => Favorites.instance.toggle(article),
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
  Widget build(BuildContext context) => Container(
    color: article.accentColorValue.withValues(alpha: 0.18),
    alignment: Alignment.center,
    child: Icon(article.iconData, color: article.accentColorValue, size: 28),
  );
}
