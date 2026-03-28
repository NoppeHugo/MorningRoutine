import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../shared/providers/storage_provider.dart';
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
    return AppScaffold(
      title: 'Réglages',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ROUTINE section
          _buildSectionHeader('ROUTINE'),
          _buildSectionGroup([
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
          ]),

          // NOTIFICATIONS section
          _buildSectionHeader('NOTIFICATIONS'),
          _buildSectionGroup([
            SettingsTile(
              title: 'Rappel matinal',
              trailing: CupertinoSwitch(
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
          ]),

          // SONS & VIBRATIONS section
          _buildSectionHeader('SONS & VIBRATIONS'),
          _buildSectionGroup([
            SettingsTile(
              title: 'Sons',
              trailing: CupertinoSwitch(
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
              trailing: CupertinoSwitch(
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
              isLast: true,
            ),
          ]),

          // ABOUT section
          _buildSectionHeader('À PROPOS'),
          _buildSectionGroup([
            SettingsTile(
              title: 'Version',
              trailing: Text(
                AppConstants.appVersion,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              isLast: true,
            ),
          ]),

          // Reset section
          _buildSectionHeader(''),
          _buildSectionGroup([
            SettingsTile(
              title: 'Réinitialiser les données',
              titleColor: AppColors.error,
              onTap: () => _confirmReset(context),
              isLast: true,
            ),
          ]),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSectionGroup(List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: tiles,
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
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Réinitialiser ?'),
        message: const Text(
          'Toutes tes données seront supprimées (routine, scores, streak). Cette action est irréversible.',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(ctx);
              await settingsRepositoryInstance.resetAllData();
              if (context.mounted) {
                ref.read(isOnboardingCompletedProvider.notifier).state =
                    false;
                context.go('/onboarding');
              }
            },
            child: const Text('Réinitialiser'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Annuler'),
        ),
      ),
    );
  }
}
