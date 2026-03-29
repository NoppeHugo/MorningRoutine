import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../shared/providers/storage_provider.dart';
import '../../../paywall/presentation/premium_controller.dart';
import '../../data/settings_repository.dart';
import '../../domain/settings_model.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late SettingsModel _settings;

  @override
  void initState() {
    super.initState();
    _settings = settingsRepositoryInstance.loadSettings();
  }

  Future<void> _saveSettings() async {
    await settingsRepositoryInstance.saveSettings(_settings);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumControllerProvider).isPremium;

    return AppScaffold(
      title: 'Réglages',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // PRO banner
          if (!isPremium) ...[
            _buildProBanner(context),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ROUTINE section
          _buildSectionTitle('ROUTINE'),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: 'Heure de réveil',
            trailing: Text(
              DurationUtils.formatTimeOfDay(_settings.wakeTime),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            onTap: () => _pickTime(
              context,
              initial: _settings.wakeTime,
              onPicked: (time) {
                setState(() {
                  _settings = _settings.copyWith(wakeTime: time);
                });
                _saveSettings();
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // NOTIFICATIONS section
          _buildSectionTitle('NOTIFICATIONS'),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: 'Rappel matinal',
            trailing: Switch(
              value: _settings.notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _settings =
                      _settings.copyWith(notificationsEnabled: value);
                });
                _saveSettings();
              },
            ),
          ),
          if (_settings.notificationsEnabled)
            SettingsTile(
              title: 'Heure du rappel',
              trailing: Text(
                DurationUtils.formatTimeOfDay(_settings.notificationTime),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              onTap: () => _pickTime(
                context,
                initial: _settings.notificationTime,
                onPicked: (time) {
                  setState(() {
                    _settings =
                        _settings.copyWith(notificationTime: time);
                  });
                  _saveSettings();
                },
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          // SONS & VIBRATIONS section
          _buildSectionTitle('SONS & VIBRATIONS'),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: 'Sons',
            trailing: Switch(
              value: _settings.soundEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(soundEnabled: value);
                });
                _saveSettings();
              },
            ),
          ),
          SettingsTile(
            title: 'Vibrations',
            trailing: Switch(
              value: _settings.vibrationEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _settings =
                      _settings.copyWith(vibrationEnabled: value);
                });
                _saveSettings();
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ABOUT section
          _buildSectionTitle('À PROPOS'),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: 'Version',
            trailing: Text(
              AppConstants.appVersion,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SettingsTile(
            title: 'Politique de confidentialité',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textTertiary,
            ),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          SettingsTile(
            title: 'Réinitialiser les données',
            titleColor: AppColors.error,
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.paywall),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.secondary.withValues(alpha: 0.6),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 28)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passe à Pro',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    'Blocs illimités + historique complet',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textOnPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context, {
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text(
          'Toutes tes données seront supprimées (routine, scores, streak). Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await settingsRepositoryInstance.resetAllData();
              if (context.mounted) {
                ref.read(isOnboardingCompletedProvider.notifier).state =
                    false;
                context.go('/onboarding');
              }
            },
            child: Text(
              'Réinitialiser',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
