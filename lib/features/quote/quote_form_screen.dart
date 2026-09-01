import '../../core/quote_history.dart';
import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/cart.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../../data/quote_request.dart';

class QuoteFormScreen extends StatefulWidget {
  final List<Article> articles;

  const QuoteFormScreen({super.key, required this.articles});

  /// Pratique pour l'appel depuis une fiche article unique.
  QuoteFormScreen.single({super.key, required Article article}) : articles = [article];

  @override
  State<QuoteFormScreen> createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  bool _submitting = false;
  Map<String, String>? _fieldErrors;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = AppL10n.s;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _fieldErrors = null;
    });

    try {
      final total = widget.articles.fold(0.0, (sum, a) => sum + a.price);
      final quote = await ApiClient.submitQuote(
        QuoteRequestPayload(
          articleIds: widget.articles.map((a) => a.id).toList(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
      final submitted = SubmittedQuote(
        id: quote.id,
        articleIds: quote.articleIds,
        name: quote.name,
        email: quote.email,
        phone: quote.phone,
        message: quote.message,
        status: quote.status,
        createdAt: quote.createdAt,
        totalPrice: total,
      );
      await QuoteHistory.instance.addQuote(submitted);
      if (!mounted) return;
      Cart.instance.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.quoteSent)),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } on ApiException catch (e) {
      setState(() => _fieldErrors = e.fieldErrors);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppL10n.s;
    final total = widget.articles.fold(0.0, (sum, a) => sum + a.price);

    return Scaffold(
      appBar: AppBar(title: Text(s.quoteTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.articles.map((a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(a.iconData, size: 16, color: AppColors.gold),
                              const SizedBox(width: 8),
                              Expanded(child: Text(a.name, style: const TextStyle(fontSize: 12.5))),
                              Text('${a.price.toStringAsFixed(0)} DT',
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                    if (widget.articles.length > 1) ...[
                      const Divider(color: AppColors.border, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(s.totalEstimated, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${total.toStringAsFixed(0)} DT',
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: s.fullName, errorText: _fieldErrors?['name']),
                validator: (v) => (v == null || v.trim().isEmpty) ? s.fieldRequired : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: s.email, errorText: _fieldErrors?['email']),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return s.fieldRequired;
                  if (!v.contains('@')) return s.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: s.phone, errorText: _fieldErrors?['phone']),
                validator: (v) => (v == null || v.trim().length < 8) ? s.invalidPhone : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: s.messageNotes,
                  hintText: s.messageHint,
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF14150F)),
                        )
                      : Text(s.sendQuote),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
