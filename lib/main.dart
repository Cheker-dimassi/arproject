import 'core/api_client.dart';
import 'core/quote_history.dart';
import 'core/cart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/favorites.dart';
import 'core/l10n.dart';
import 'core/theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Favorites.instance.init();
  await Cart.instance.init();
  await QuoteHistory.instance.init();
  await AppL10n.init();
  await ApiClient.loadCache();
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;
  runApp(SmartRoomApp(showOnboarding: !onboardingDone));
}

class SmartRoomApp extends StatelessWidget {
  final bool showOnboarding;
  const SmartRoomApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppL10n.notifier,
      builder: (context, _) {
        final isAr = AppL10n.currentLanguage == AppLanguage.ar;
        return MaterialApp(
          title: 'Smart Room',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          builder: (context, child) {
            return Directionality(
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: showOnboarding ? const OnboardingScreen() : const AppShell(),
        );
      },
    );
  }
}
