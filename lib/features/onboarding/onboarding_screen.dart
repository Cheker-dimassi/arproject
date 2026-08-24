import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../core/l10n.dart';
import '../shell/app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;
  static const int _total = 3;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            children: const [_OPage1(), _OPage2(), _OPage3()],
          ),
          Positioned(
            top: 52, right: 24,
            child: TextButton(
              onPressed: _finish,
              child: Text(AppL10n.s.skip, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_total, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _page == i ? AppColors.gold : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_page < _total - 1) {
                          _ctrl.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          );
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page == _total - 1 ? AppL10n.s.getStarted : (AppL10n.currentLanguage == AppLanguage.ar ? 'التالي' : (AppL10n.currentLanguage == AppLanguage.en ? 'Next' : 'Suivant'))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OPageBase extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _OPageBase({required this.icon, required this.color, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 100, 32, 160),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
            ),
            child: Icon(icon, size: 44, color: color),
          ),
          const SizedBox(height: 40),
          Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24, height: 1.3)),
          const SizedBox(height: 16),
          Text(body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.5, color: AppColors.textSecondary, height: 1.65)),
        ],
      ),
    );
  }
}

class _OPage1 extends StatelessWidget {
  const _OPage1();
  @override
  Widget build(BuildContext context) => _OPageBase(
    icon: Icons.auto_awesome,
    color: AppColors.gold,
    title: AppL10n.s.onboardingTitle1,
    body: AppL10n.s.onboardingBody1,
  );
}

class _OPage2 extends StatelessWidget {
  const _OPage2();
  @override
  Widget build(BuildContext context) => _OPageBase(
    icon: Icons.view_in_ar,
    color: AppColors.tealAccent,
    title: AppL10n.s.onboardingTitle2,
    body: AppL10n.s.onboardingBody2,
  );
}

class _OPage3 extends StatelessWidget {
  const _OPage3();
  @override
  Widget build(BuildContext context) => _OPageBase(
    icon: Icons.request_quote_outlined,
    color: AppColors.gold,
    title: AppL10n.s.onboardingTitle3,
    body: AppL10n.s.onboardingBody3,
  );
}
