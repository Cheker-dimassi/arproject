import 'package:flutter/material.dart';
import '../../core/cart.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../catalog/catalog_screen.dart';
import '../search/search_screen.dart';
import '../ar/ar_picker_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppL10n.notifier,
      builder: (context, _) {
        final lang = AppL10n.currentLanguage;
        final screens = [
          CatalogScreen(key: ValueKey('catalog_$lang')),
          SearchScreen(key: ValueKey('search_$lang')),
          ArPickerScreen(key: ValueKey('ar_$lang')),
          CartScreen(key: ValueKey('cart_$lang')),
          ProfileScreen(key: ValueKey('profile_$lang')),
        ];

        return Scaffold(
          body: IndexedStack(index: _index, children: screens),
          bottomNavigationBar: _BottomBar(
            index: _index,
            onTap: (i) => setState(() => _index = i),
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _BottomBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    return Material(
      color: AppColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.6)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _navItem(Icons.home_outlined, 0, s.catalog),
                _navItem(Icons.search, 1, s.search),
                _cameraItem(s.ar),
                _cartItem(s.cart),
                _navItem(Icons.person_outline, 4, s.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int i, String tooltip) {
    final selected = index == i;
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () => onTap(i),
          child: SizedBox.expand(
            child: Icon(
              icon,
              size: 24,
              color: selected ? AppColors.gold : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cameraItem(String tooltip) {
    final selected = index == 2;
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () => onTap(2),
          child: SizedBox.expand(
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? AppColors.gold : AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 20,
                  color: Color(0xFF14150F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartItem(String tooltip) {
    final selected = index == 3;
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () => onTap(3),
          child: SizedBox.expand(
            child: Center(
              child: ListenableBuilder(
                listenable: Cart.instance,
                builder: (context, _) {
                  final count = Cart.instance.count;
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        selected ? Icons.shopping_bag : Icons.shopping_bag_outlined,
                        size: 24,
                        color: selected ? AppColors.gold : AppColors.textSecondary,
                      ),
                      if (count > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF14150F),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
