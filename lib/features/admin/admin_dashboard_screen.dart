import 'package:flutter/material.dart';
import '../../core/admin_session.dart';
import '../../core/api_client.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/quote_request.dart';
import '../../widgets/state_message.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<SubmittedQuote> _quotes = [];
  bool _loading = true;
  String? _error;
  QuoteStatus? _selectedFilter; // null = all

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await ApiClient.fetchAllQuotesAdmin(
        username: AdminSession.instance.username,
        password: AdminSession.instance.password,
      );
      if (!mounted) return;
      setState(() {
        _quotes = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _updateStatus(SubmittedQuote quote, QuoteStatus newStatus) async {
    final s = AppL10n.s;
    try {
      final updated = await ApiClient.updateQuoteStatusAdmin(
        id: quote.id,
        status: newStatus.backendString,
        username: AdminSession.instance.username,
        password: AdminSession.instance.password,
      );
      if (!mounted) return;
      setState(() {
        final idx = _quotes.indexWhere((q) => q.id == quote.id);
        if (idx != -1) {
          _quotes[idx] = updated;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.statusUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  void _showStatusDialog(SubmittedQuote quote) {
    final s = AppL10n.s;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${s.updateStatus} - #${quote.id}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...QuoteStatus.values.map((st) {
                final label = switch (st) {
                  QuoteStatus.sent => s.statusSent,
                  QuoteStatus.inProgress => s.statusInProgress,
                  QuoteStatus.processed => s.statusProcessed,
                };
                final color = switch (st) {
                  QuoteStatus.sent => AppColors.gold,
                  QuoteStatus.inProgress => AppColors.tealAccent,
                  QuoteStatus.processed => const Color(0xFF4CAF50),
                };
                final selected = quote.status == st;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  title: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected ? color : AppColors.textPrimary,
                    ),
                  ),
                  trailing: selected ? Icon(Icons.check, color: color) : null,
                  onTap: () {
                    Navigator.pop(context);
                    if (!selected) {
                      _updateStatus(quote, st);
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;

    final totalCount = _quotes.length;
    final pendingCount = _quotes.where((q) => q.status == QuoteStatus.sent).length;
    final inProgressCount = _quotes.where((q) => q.status == QuoteStatus.inProgress).length;
    final processedCount = _quotes.where((q) => q.status == QuoteStatus.processed).length;

    final filteredQuotes = _selectedFilter == null
        ? _quotes
        : _quotes.where((q) => q.status == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(s.adminPortal),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: s.retry,
            onPressed: _loadQuotes,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: s.logout,
            onPressed: () async {
              final nav = Navigator.of(context);
              await AdminSession.instance.logout();
              nav.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : _error != null
                ? StateMessage(
                    icon: Icons.wifi_off,
                    title: s.loadError,
                    subtitle: _error!,
                    onRetry: _loadQuotes,
                  )
                : RefreshIndicator(
                    onRefresh: _loadQuotes,
                    color: AppColors.gold,
                    child: CustomScrollView(
                      slivers: [
                        // Metrics row
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Row(
                              children: [
                                _MetricCard(
                                  label: s.totalQuotes,
                                  count: totalCount,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(width: 8),
                                _MetricCard(
                                  label: s.pendingQuotes,
                                  count: pendingCount,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(width: 8),
                                _MetricCard(
                                  label: s.inProgressQuotes,
                                  count: inProgressCount,
                                  color: AppColors.tealAccent,
                                ),
                                const SizedBox(width: 8),
                                _MetricCard(
                                  label: s.processedQuotes,
                                  count: processedCount,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Filters pills
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterTab(
                                    label: s.filterAll,
                                    count: totalCount,
                                    selected: _selectedFilter == null,
                                    onTap: () => setState(() => _selectedFilter = null),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterTab(
                                    label: s.pendingQuotes,
                                    count: pendingCount,
                                    selected: _selectedFilter == QuoteStatus.sent,
                                    onTap: () => setState(() => _selectedFilter = QuoteStatus.sent),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterTab(
                                    label: s.inProgressQuotes,
                                    count: inProgressCount,
                                    selected: _selectedFilter == QuoteStatus.inProgress,
                                    onTap: () => setState(() => _selectedFilter = QuoteStatus.inProgress),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterTab(
                                    label: s.processedQuotes,
                                    count: processedCount,
                                    selected: _selectedFilter == QuoteStatus.processed,
                                    onTap: () => setState(() => _selectedFilter = QuoteStatus.processed),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Quotes list
                        filteredQuotes.isEmpty
                            ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    s.noQuotes,
                                    style: const TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              )
                            : SliverPadding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final quote = filteredQuotes[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: _AdminQuoteCard(
                                          quote: quote,
                                          onChangeStatus: () => _showStatusDialog(quote),
                                        ),
                                      );
                                    },
                                    childCount: filteredQuotes.length,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _MetricCard({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _FilterTab({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
            width: 0.8,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? const Color(0xFF14150F) : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _AdminQuoteCard extends StatelessWidget {
  final SubmittedQuote quote;
  final VoidCallback onChangeStatus;
  const _AdminQuoteCard({required this.quote, required this.onChangeStatus});

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    final dateStr =
        '${quote.createdAt.day.toString().padLeft(2, '0')}/${quote.createdAt.month.toString().padLeft(2, '0')}/${quote.createdAt.year} ${quote.createdAt.hour.toString().padLeft(2, '0')}:${quote.createdAt.minute.toString().padLeft(2, '0')}';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${quote.id} - ${quote.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
              InkWell(
                onTap: onChangeStatus,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.edit_note, size: 14, color: statusColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const Divider(color: AppColors.border, height: 20),

          // Contact details
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(quote.phone, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(width: 14),
              const Icon(Icons.email_outlined, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  quote.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),

          if (quote.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quote.message,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              ),
            ),
          ],

          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: quote.articleIds.map((id) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
