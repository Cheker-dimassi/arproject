import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/cart.dart';
import '../../core/favorites.dart';
import '../../core/theme.dart';
import '../../core/l10n.dart';
import '../../data/article.dart';
import '../quote/quote_form_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final bool openArImmediately;

  const ArticleDetailScreen({
    super.key,
    required this.article,
    this.openArImmediately = false,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _viewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.openArImmediately) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToViewer());
    }
  }

  void _scrollToViewer() {
    final ctx = _viewerKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        alignment: 0.1);
    }
  }

  void _share() {
    final article = widget.article;
    Share.share('${AppL10n.s.shareText}: ${article.name} - ${article.price.toStringAsFixed(0)} DT');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            flexibleSpace: FlexibleSpaceBar(background: _HeroVisual(article: article)),
            actions: [
              // Share button
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: _share,
                tooltip: AppL10n.s.share,
              ),
              // Favorite button
              ListenableBuilder(
                listenable: Favorites.instance,
                builder: (context, _) {
                  final isFav = Favorites.instance.contains(article.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.gold : AppColors.textPrimary,
                    ),
                    onPressed: () => Favorites.instance.toggle(article),
                    tooltip: isFav ? AppL10n.s.removeFromFavorites : AppL10n.s.addToFavorites,
                  );
                },
              ),
              // Cart button
              ListenableBuilder(
                listenable: Cart.instance,
                builder: (context, _) {
                  final inCart = Cart.instance.contains(article.id);
                  return IconButton(
                    icon: Icon(inCart ? Icons.check_circle : Icons.add_shopping_cart,
                        color: inCart ? AppColors.gold : AppColors.textPrimary),
                    onPressed: () => Cart.instance.toggle(article),
                    tooltip: inCart ? AppL10n.s.removeFromCart : AppL10n.s.addToCart,
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Pill(text: article.category, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      _Pill(
                        text: article.isWallMounted ? AppL10n.s.wallMounted : AppL10n.s.floorMounted,
                        color: AppColors.tealAccent,
                        icon: article.isWallMounted ? Icons.push_pin_outlined : Icons.crop_square,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(article.name, style: Theme.of(context).textTheme.headlineSmall)),
                      const SizedBox(width: 12),
                      Text('${article.price.toStringAsFixed(0)} DT',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _SpecTile(icon: Icons.straighten, label: AppL10n.s.dimensions, value: article.dimensions)),
                      const SizedBox(width: 10),
                      Expanded(child: _SpecTile(icon: Icons.texture, label: AppL10n.s.material, value: article.material)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(article.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 13.5)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppL10n.s.view3d, style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: [
                          const Icon(Icons.touch_app, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(AppL10n.s.tapArHint,
                              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    key: _viewerKey,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 280,
                      color: AppColors.surface,
                      child: ModelViewer(
                        backgroundColor: AppColors.surface,
                        src: article.glbAsset,
                        iosSrc: article.usdzAsset,
                        alt: article.name,
                        ar: true,
                        arPlacement: article.arPlacement,
                        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                        autoRotate: true,
                        cameraControls: true,
                        disableZoom: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QuoteFormScreen.single(article: article)),
                      ),
                      child: Text(AppL10n.s.requestSingleQuote),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  final Article article;
  const _HeroVisual({required this.article});

  @override
  Widget build(BuildContext context) {
    final image = article.displayImage ?? article.imageUrl;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (image != null)
          Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback())
        else
          _fallback(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.15), AppColors.background.withValues(alpha: 0.95)],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() => Container(
    color: article.accentColorValue.withValues(alpha: 0.22),
    alignment: Alignment.center,
    child: Icon(article.iconData, size: 72, color: article.accentColorValue),
  );
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const _Pill({required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SpecTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value.isEmpty ? '-' : value, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

