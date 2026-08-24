import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/favorites.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../article_detail/article_detail_screen.dart';
import '../favorites/favorites_screen.dart';
import 'widgets/article_card.dart';

enum SortOption { recent, nameAsc, priceAsc, priceDesc, featuredFirst }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<Article>> _futureArticles;
  String? _selectedCategory;
  SortOption _sort = SortOption.recent;
  bool _featuredOnly = false;
  String? _placementFilter;

  @override
  void initState() {
    super.initState();
    _futureArticles = ApiClient.fetchArticles();
  }

  void _reload({String? category}) {
    setState(() {
      _selectedCategory = category;
      _futureArticles = ApiClient.fetchArticles(category: category);
    });
  }

  String _getSortLabel(SortOption option) {
    final s = AppL10n.s;
    switch (option) {
      case SortOption.recent:
        return s.sortRecent;
      case SortOption.nameAsc:
        return s.sortNameAsc;
      case SortOption.priceAsc:
        return s.sortPriceAsc;
      case SortOption.priceDesc:
        return s.sortPriceDesc;
      case SortOption.featuredFirst:
        return s.sortFeatured;
    }
  }

  List<Article> _applyFiltersAndSort(List<Article> input) {
    var result = input.where((a) {
      if (_featuredOnly && !a.featured) return false;
      if (_placementFilter != null && a.placement != _placementFilter) return false;
      return true;
    }).toList();

    switch (_sort) {
      case SortOption.recent:
        break;
      case SortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.featuredFirst:
        result.sort((a, b) => (b.featured ? 1 : 0) - (a.featured ? 1 : 0));
        break;
    }
    return result;
  }

  Future<void> _openFilterSheet() async {
    final s = AppL10n.s;
    bool tempFeatured = _featuredOnly;
    String? tempPlacement = _placementFilter;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.filter, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.gold,
                    title: Text(s.featuredOnly, style: const TextStyle(fontSize: 13.5)),
                    value: tempFeatured,
                    onChanged: (v) => setSheetState(() => tempFeatured = v),
                  ),
                  const SizedBox(height: 8),
                  Text(s.placement, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChoice(label: s.all, selected: tempPlacement == null,
                          onTap: () => setSheetState(() => tempPlacement = null)),
                      _FilterChoice(label: s.floor, selected: tempPlacement == 'floor',
                          onTap: () => setSheetState(() => tempPlacement = 'floor')),
                      _FilterChoice(label: s.wall, selected: tempPlacement == 'wall',
                          onTap: () => setSheetState(() => tempPlacement = 'wall')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _featuredOnly = tempFeatured;
                          _placementFilter = tempPlacement;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(s.apply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openSortMenu(BuildContext context, Offset position) async {
    final chosen = await showMenu<SortOption>(
      context: context,
      color: AppColors.surface,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: SortOption.values
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Text(_getSortLabel(opt), style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              ))
          .toList(),
    );
    if (chosen != null) setState(() => _sort = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Article>>(
          future: _futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.gold));
            }
            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () => _reload(category: _selectedCategory),
              );
            }

            final rawArticles = snapshot.data ?? [];
            final categories = {for (final a in rawArticles) a.category}.toList()..sort();
            final articles = _applyFiltersAndSort(rawArticles);
            final activeFilterCount = (_featuredOnly ? 1 : 0) + (_placementFilter != null ? 1 : 0);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.furniture, style: Theme.of(context).textTheme.headlineSmall),
                        Row(
                          children: [
                            ListenableBuilder(
                              listenable: Favorites.instance,
                              builder: (context, _) {
                                final count = Favorites.instance.count;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const FavoritesScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: count > 0 ? AppColors.gold.withValues(alpha: 0.15) : AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: count > 0 ? AppColors.gold.withValues(alpha: 0.4) : AppColors.border,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(
                                          count > 0 ? Icons.favorite : Icons.favorite_border,
                                          size: 18,
                                          color: count > 0 ? AppColors.gold : AppColors.textPrimary,
                                        ),
                                        if (count > 0)
                                          Positioned(
                                            right: -5,
                                            top: -5,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: AppColors.gold,
                                                shape: BoxShape.circle,
                                              ),
                                              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                              child: Text(
                                                '$count',
                                                style: const TextStyle(
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF14150F),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _openFilterSheet,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: activeFilterCount > 0 ? AppColors.gold : AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(Icons.tune, size: 18,
                                        color: activeFilterCount > 0 ? const Color(0xFF14150F) : AppColors.textPrimary),
                                    if (activeFilterCount > 0)
                                      Positioned(
                                        right: -4, top: -4,
                                        child: Container(
                                          width: 8, height: 8,
                                          decoration: const BoxDecoration(color: AppColors.tealAccent, shape: BoxShape.circle),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 0, 12),
                    child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _CategoryPill(
                            label: s.all,
                            selected: _selectedCategory == null,
                            onTap: () => _reload(category: null),
                          ),
                          const SizedBox(width: 8),
                          ...categories.map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _CategoryPill(
                                  label: c,
                                  selected: _selectedCategory == c,
                                  onTap: () => _reload(category: c),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${articles.length} ${s.articlesCount}',
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                        Builder(
                          builder: (context) => GestureDetector(
                            onTapDown: (details) => _openSortMenu(context, details.globalPosition),
                            child: Row(
                              children: [
                                Text(_getSortLabel(_sort),
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final article = articles[index];
                        return ArticleCard(
                          article: article,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleDetailScreen(article: article),
                            ),
                          ),
                        );
                      },
                      childCount: articles.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChoice({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12.5, fontWeight: FontWeight.w600,
          color: selected ? const Color(0xFF14150F) : AppColors.textSecondary,
        )),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF14150F) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(AppL10n.s.retry)),
          ],
        ),
      ),
    );
  }
}
