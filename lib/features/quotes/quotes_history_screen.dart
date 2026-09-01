import 'package:flutter/material.dart';
import '../../core/l10n.dart';
import '../../core/quote_history.dart';
import '../../core/theme.dart';
import '../../data/quote_request.dart';
import '../../widgets/state_message.dart';

class QuotesHistoryScreen extends StatelessWidget {
  const QuotesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.myQuotes),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: QuoteHistory.instance,
          builder: (context, _) {
            final quotes = QuoteHistory.instance.quotes;

            if (quotes.isEmpty) {
              return StateMessage(
                icon: Icons.receipt_long_outlined,
                title: s.noQuotes,
                subtitle: s.noQuotesSubtitle,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              itemCount: quotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return _QuoteCard(quote: quote);
              },
            );
          },
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final SubmittedQuote quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    final dateStr =
        '${quote.createdAt.day.toString().padLeft(2, '0')}/${quote.createdAt.month.toString().padLeft(2, '0')}/${quote.createdAt.year}';

    final (statusLabel, statusColor) = switch (quote.status) {
      QuoteStatus.sent => (s.statusSent, AppColors.gold),
      QuoteStatus.inProgress => (s.statusInProgress, AppColors.tealAccent),
      QuoteStatus.processed => (s.statusProcessed, const Color(0xFF4CAF50)),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: #ID, Date, Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${s.quoteNumber}${quote.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 24),

          // Contact details
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  quote.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                quote.phone,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.email_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  quote.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),

          if (quote.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quote.message,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
            ),
          ],

          const SizedBox(height: 12),
          // Footer: Articles count & Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${quote.articleIds.length} ${s.articlesCount}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              if (quote.totalPrice > 0)
                Text(
                  '${quote.totalPrice.toStringAsFixed(0)} DT',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
