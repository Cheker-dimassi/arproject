import '../../core/quote_history.dart';
import '../quotes/quotes_history_screen.dart';
import 'package:flutter/material.dart';
import '../../core/favorites.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../favorites/favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _setLanguage(AppLanguage lang) {
    setState(() {
      AppL10n.setLanguage(lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppL10n.notifier,
      builder: (context, _) {
        final s = AppL10n.s;
        final currentLang = AppL10n.currentLanguage;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.profile, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),

                // Language switcher card
                _SectionCard(
                  icon: Icons.language,
                  title: s.language,
                  child: Column(
                    children: AppLanguage.values.map((lang) {
                      final name = switch (lang) {
                        AppLanguage.fr => 'Français',
                        AppLanguage.en => 'English',
                        AppLanguage.ar => 'العربية',
                      };
                      final selected = currentLang == lang;

                      return InkWell(
                        onTap: () => _setLanguage(lang),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.gold.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected ? AppColors.gold : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                                    color: selected ? AppColors.gold : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle, color: AppColors.gold, size: 18),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Favorites card
                _SectionCard(
                  icon: Icons.favorite_border,
                  title: s.favorites,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.favorites,
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          ListenableBuilder(
                            listenable: Favorites.instance,
                            builder: (context, _) => Text(
                              '${Favorites.instance.count}',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Quotes card
                _SectionCard(
                  icon: Icons.receipt_long_outlined,
                  title: s.myQuotes,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuotesHistoryScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.myQuotes,
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          ListenableBuilder(
                            listenable: QuoteHistory.instance,
                            builder: (context, _) => Text(
                              '${QuoteHistory.instance.count}',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // About card
                _SectionCard(
                  icon: Icons.info_outline,
                  title: s.about,
                  child: Text(
                    s.aboutBody,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.55),
                  ),
                ),
                const SizedBox(height: 14),

                // Version
                Center(
                  child: Text(
                    '${s.version} 1.0.0',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
