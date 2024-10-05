import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_eat/bloc/settings/settings_cubit.dart';
import 'package:lets_eat/helpers/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final prefHelper = SharedPreferencesHelper();
  late final SettingsCubit settingsCubit;

  @override
  void initState() {
    settingsCubit = SettingsCubit(prefHelper);
    super.initState();
    settingsCubit.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences")),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: settingsCubit,
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              ListTile(
                enabled: Platform.isAndroid,
                title: const Text("Restaurant Notification"),
                subtitle: Text(
                  "Notification ${state.settings.notification ? "enabled" : "disabled"}"
                  "${!Platform.isAndroid ? " (Android only)" : ""}",
                ),
                trailing: Switch(
                  value: state.settings.notification,
                  onChanged: (v) {
                    if (!Platform.isAndroid) return;
                    settingsCubit.setNotificationSettings(v);
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              )
            ],
          );
        },
      ),
    );
  }
}
