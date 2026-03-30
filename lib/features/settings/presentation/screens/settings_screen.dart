import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../shared/providers/storage_provider.dart';
import '../../../notifications/data/notification_service.dart';
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
    final locale = ref.watch(appLanguageProvider);
    final langCode = locale.languageCode;

    return AppScaffold(
      title: AppI18n.t('settings.title', langCode),
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
          _buildSectionTitle(AppI18n.t('settings.section.routine', langCode)),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: AppI18n.t('settings.wakeTime', langCode),
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
          _buildSectionTitle(AppI18n.t('settings.section.notifications', langCode)),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: AppI18n.t('settings.morningReminder', langCode),
            trailing: Switch(
              value: _settings.notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) async {
                setState(() {
                  _settings =
                      _settings.copyWith(notificationsEnabled: value);
                });
                await _saveSettings();
                if (value) {
                  await NotificationService.instance.requestPermissions();
                  await NotificationService.instance
                      .scheduleMorningReminder(_settings.notificationTime);
                } else {
                  await NotificationService.instance.cancelAll();
                }
              },
            ),
          ),
          if (_settings.notificationsEnabled)
            SettingsTile(
              title: AppI18n.t('settings.reminderTime', langCode),
              trailing: Text(
                DurationUtils.formatTimeOfDay(_settings.notificationTime),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              onTap: () => _pickTime(
                context,
                initial: _settings.notificationTime,
                onPicked: (time) async {
                  setState(() {
                    _settings =
                        _settings.copyWith(notificationTime: time);
                  });
                  await _saveSettings();
                  if (_settings.notificationsEnabled) {
                    await NotificationService.instance
                        .scheduleMorningReminder(time);
                  }
                },
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          // SONS & VIBRATIONS section
          _buildSectionTitle(AppI18n.t('settings.section.sound', langCode)),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: AppI18n.t('settings.sound', langCode),
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
            title: AppI18n.t('settings.vibration', langCode),
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

          // LANGUAGE section
          _buildSectionTitle(AppI18n.t('settings.section.language', langCode)),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: AppI18n.t('settings.language', langCode),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _settings.languageCode,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                items: supportedLanguageCodes
                    .map(
                      (code) => DropdownMenuItem<String>(
                        value: code,
                        child: Text(languageLabel(code)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() {
                    _settings = _settings.copyWith(
                      languageCode: value,
                      hasChosenLanguage: true,
                    );
                  });
                  await _saveSettings();
                  await ref
                      .read(appLanguageProvider.notifier)
                      .setLanguage(value);
                },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ABOUT section
          _buildSectionTitle(AppI18n.t('settings.section.about', langCode)),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            title: AppI18n.t('settings.version', langCode),
            trailing: Text(
              AppConstants.appVersion,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SettingsTile(
            title: AppI18n.t('settings.privacyPolicy', langCode),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textTertiary,
            ),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          SettingsTile(
            title: AppI18n.t('settings.resetData', langCode),
            titleColor: AppColors.error,
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProBanner(BuildContext context) {
    final langCode = ref.read(appLanguageProvider).languageCode;
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
            const Icon(
              Icons.workspace_premium_rounded,
              size: 28,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppI18n.t('settings.goPro', langCode),
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    AppI18n.t('settings.goProSub', langCode),
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
    final langCode = ref.read(appLanguageProvider).languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppI18n.t('settings.resetTitle', langCode)),
        content: Text(AppI18n.t('settings.resetBody', langCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppI18n.t('common.cancel', langCode)),
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
              AppI18n.t('settings.resetData', langCode),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
