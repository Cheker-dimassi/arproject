import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api_client.dart';
import '../../core/app_config.dart';
import '../../core/theme.dart';
import '../../data/article.dart';
import '../../data/reconstruction_job.dart';

/// Ecran de generation de modele 3D a partir d'une photo.
///
/// Pipeline :
///   1. L'utilisateur choisit une photo (galerie ou camera).
///   2. La photo est envoyee au backend (POST generate-3d).
///   3. Un timer interroge le statut toutes les 12 secondes.
///   4. Quand DONE -> affichage du GLB genere + bouton pour voir en AR.
class Generate3dScreen extends StatefulWidget {
  final Article article;

  const Generate3dScreen({super.key, required this.article});

  @override
  State<Generate3dScreen> createState() => _Generate3dScreenState();
}

class _Generate3dScreenState extends State<Generate3dScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();

  File? _selectedPhoto;
  ReconstructionJob? _job;
  bool _isSubmitting = false;
  String? _errorMessage;

  Timer? _pollTimer;
  int _pollCount = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim =
        Tween<double>(begin: 0.7, end: 1.0).animate(_pulseController);

    // Si un job est deja en cours, on reprend le polling
    _checkExistingJob();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logique
  // ---------------------------------------------------------------------------

  Future<void> _checkExistingJob() async {
    try {
      final job = await ApiClient.getReconstructionStatus(widget.article.id);
      if (job.isInProgress && mounted) {
        setState(() => _job = job);
        _startPolling();
      } else if (mounted) {
        setState(() => _job = job);
      }
    } catch (_) {
      // Pas de job existant -> ecran vide initial
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 90,
    );
    if (picked == null) return;
    setState(() {
      _selectedPhoto = File(picked.path);
      _job = null;
      _errorMessage = null;
    });
  }

  Future<void> _submitPhoto() async {
    if (_selectedPhoto == null) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final job = await ApiClient.startReconstruction(
        articleId: widget.article.id,
        photo: _selectedPhoto!,
        adminUsername: AppConfig.adminUsername,
        adminPassword: AppConfig.adminPassword,
      );
      setState(() {
        _job = job;
        _isSubmitting = false;
      });
      _startPolling();
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur inattendue : $e';
        _isSubmitting = false;
      });
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollCount = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 12), (_) async {
      if (!mounted) {
        _pollTimer?.cancel();
        return;
      }
      try {
        final updated =
            await ApiClient.getReconstructionStatus(widget.article.id);
        setState(() {
          _job = updated;
          _pollCount++;
        });
        if (!updated.isInProgress) {
          _pollTimer?.cancel();
        }
      } catch (_) {
        // Ignorer les erreurs reseau transitoires
      }
    });
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Générer un modèle 3D',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              widget.article.name,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _InfoCard(),
              const SizedBox(height: 20),

              // Zone de selection de la photo
              _PhotoPickerArea(
                selectedPhoto: _selectedPhoto,
                onPickGallery: () => _pickPhoto(ImageSource.gallery),
                onPickCamera: () => _pickPhoto(ImageSource.camera),
              ),

              const SizedBox(height: 16),

              // Message d'erreur
              if (_errorMessage != null) ...[
                _ErrorBanner(message: _errorMessage!),
                const SizedBox(height: 16),
              ],

              // Bouton lancer la generation
              if (_selectedPhoto != null && (_job == null || _job!.isFailed))
                _SubmitButton(
                  isLoading: _isSubmitting,
                  onPressed: _submitPhoto,
                ),

              // Suivi du job en cours ou termine
              if (_job != null) ...[
                const SizedBox(height: 20),
                _JobStatusCard(
                  job: _job!,
                  pollCount: _pollCount,
                  pulseAnim: _pulseAnim,
                  articleId: widget.article.id,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Sous-composants prives
// -----------------------------------------------------------------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates_outlined,
                  color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'Conseils pour un bon resultat',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Prenez une photo du meuble sur fond uni. '
            'L''IA TripoSR generera un modele GLB en 2 a 10 minutes.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Tip(icon: Icons.wb_sunny_outlined, text: 'Bonne lumiere'),
              _Tip(icon: Icons.crop_free, text: 'Fond uni'),
              _Tip(icon: Icons.rotate_right, text: 'Angle 45 deg'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _PhotoPickerArea extends StatelessWidget {
  final File? selectedPhoto;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  const _PhotoPickerArea({
    required this.selectedPhoto,
    required this.onPickGallery,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (selectedPhoto != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedPhoto!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        size: 48, color: AppColors.textSecondary),
                    SizedBox(height: 8),
                    Text(
                      'Aucune photo selectionnee',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickGallery,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Galerie'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickCamera,
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.black, strokeWidth: 2))
            : const Icon(Icons.auto_awesome, color: Colors.black),
        label: Text(
          isLoading ? 'Soumission en cours...' : 'Generer le modele 3D',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style:
                      const TextStyle(color: Colors.redAccent, fontSize: 13))),
        ],
      ),
    );
  }
}

class _JobStatusCard extends StatelessWidget {
  final ReconstructionJob job;
  final int pollCount;
  final Animation<double> pulseAnim;
  final String articleId;

  const _JobStatusCard({
    required this.job,
    required this.pollCount,
    required this.pulseAnim,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          // Icone animee
          _StatusIcon(job: job, pulseAnim: pulseAnim),
          const SizedBox(height: 14),
          // Statut
          Text(
            _statusLabel,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _borderColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            job.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          // Compteur de polls
          if (job.isInProgress) ...[
            const SizedBox(height: 10),
            Text(
              'Verification ${pollCount + 1} - Verification toutes les 12 secondes...',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
          // Bouton voir en AR si DONE
          if (job.isDone && job.glbAssetUrl != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openInAR(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.view_in_ar, color: Colors.black),
                label: const Text(
                  'Voir le modele en AR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.glbAssetUrl!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontFamily: 'monospace'),
            ),
          ],
        ],
      ),
    );
  }

  void _openInAR(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Modele genere ! Retournez sur la fiche article pour le voir en AR.'),
        backgroundColor: AppColors.goldDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Color get _borderColor {
    if (job.isDone) return AppColors.tealAccent;
    if (job.isFailed) return Colors.redAccent;
    return AppColors.gold;
  }

  String get _statusLabel {
    switch (job.status) {
      case 'PENDING':
        return 'En attente...';
      case 'PROCESSING':
        return 'Generation en cours...';
      case 'DONE':
        return 'Modele 3D genere !';
      case 'FAILED':
        return 'Generation echouee';
      default:
        return job.status;
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final ReconstructionJob job;
  final Animation<double> pulseAnim;
  const _StatusIcon({required this.job, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    if (job.isDone) {
      return const Icon(Icons.check_circle_outline,
          color: AppColors.tealAccent, size: 52);
    }
    if (job.isFailed) {
      return const Icon(Icons.error_outline, color: Colors.redAccent, size: 52);
    }
    // PENDING / PROCESSING : icone animee
    return ScaleTransition(
      scale: pulseAnim,
      child: const Icon(Icons.motion_photos_on_outlined,
          color: AppColors.gold, size: 52),
    );
  }
}