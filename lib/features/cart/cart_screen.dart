import 'package:flutter/material.dart';
import '../../core/cart.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../widgets/state_message.dart';
import '../quote/quote_form_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: Cart.instance,
        builder: (context, _) {
          final items = Cart.instance.items;
          final s = AppL10n.s;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.myCart, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  s.cartSubtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: items.isEmpty
                      ? StateMessage(
                          icon: Icons.shopping_bag_outlined,
                          title: s.emptyCart,
                          subtitle: s.emptyCartSubtitle,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final a = items[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border, width: 0.6),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 48, height: 48,
                                      child: a.displayImage != null
                                          ? Image.network(a.displayImage!, fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                    color: a.accentColorValue.withValues(alpha: 0.2),
                                                    child: Icon(a.iconData, color: a.accentColorValue, size: 18),
                                                  ))
                                          : Container(
                                              color: a.accentColorValue.withValues(alpha: 0.2),
                                              child: Icon(a.iconData, color: a.accentColorValue, size: 18),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                        Text('${a.price.toStringAsFixed(0)} DT',
                                            style: const TextStyle(fontSize: 11.5, color: AppColors.gold)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                                    onPressed: () => Cart.instance.remove(a.id),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                if (items.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.totalEstimated, style: const TextStyle(color: AppColors.textSecondary)),
                        Text('${Cart.instance.total.toStringAsFixed(0)} DT',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QuoteFormScreen(articles: items)),
                      ),
                      child: Text(s.requestGroupQuote),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
