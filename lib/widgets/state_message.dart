import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Etat vide/erreur reutilisable. Objectif : qu'un ecran sans donnees ou
/// en echec de chargement soit toujours clairement lisible — jamais
/// juste "vide" a l'oeil, meme quand il n'y a effectivement rien a
/// afficher (panier vide, aucun resultat de recherche, etc.).
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;
  final String retryLabel;

  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
    this.retryLabel = 'Reessayer',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 14),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
            ],
          ],
        ),
      ),
    );
  }
}
