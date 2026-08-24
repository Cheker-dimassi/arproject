import '../../../core/l10n.dart';
import 'package:flutter/material.dart';
import '../../../core/cart.dart';
import '../../../core/favorites.dart';
import '../../../core/theme.dart';
import '../../../data/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 56,
              child: _CardVisual(article: article),
            ),
            Expanded(
              flex: 44,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 12.5, height: 1.25),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          article.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${article.price.toStringAsFixed(0)} DT',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                        Row(
                          children: [
                            // Favorite button
                            ListenableBuilder(
                              listenable: Favorites.instance,
                              builder: (context, _) {
                                final isFav = Favorites.instance.contains(article.id);
                                return GestureDetector(
                                  onTap: () => Favorites.instance.toggle(article),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      size: 18,
                                      color: isFav ? AppColors.gold : AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Cart button
                            ListenableBuilder(
                              listenable: Cart.instance,
                              builder: (context, _) {
                                final inCart = Cart.instance.contains(article.id);
                                return GestureDetector(
                                  onTap: () => Cart.instance.toggle(article),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: inCart ? AppColors.gold : AppColors.surfaceAlt,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      inCart ? Icons.check : Icons.add,
                                      size: 13,
                                      color: inCart ? const Color(0xFF14150F) : AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardVisual extends StatelessWidget {
  final Article article;
  const _CardVisual({required this.article});

  @override
  Widget build(BuildContext context) {
    final image = article.displayImage;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (image != null)
          Image.network(
            image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : _placeholder(article),
            errorBuilder: (context, error, stackTrace) => _placeholder(article),
          )
        else
          _placeholder(article),
        Positioned(
          left: 8, top: 8,
          child: Row(
            children: [
              if (article.featured) _Badge(label: AppL10n.s.featuredBadge, color: AppColors.gold),
              if (article.isWallMounted) ...[
                const SizedBox(width: 6),
                _Badge(label: AppL10n.s.wall, color: AppColors.tealAccent, icon: Icons.push_pin_outlined),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _placeholder(Article article) {
    return Container(
      color: article.accentColorValue.withValues(alpha: 0.18),
      alignment: Alignment.center,
      child: Icon(article.iconData, color: article.accentColorValue, size: 34),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const _Badge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xCC0E0F13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 9, color: color), const SizedBox(width: 3)],
          Text(label, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
