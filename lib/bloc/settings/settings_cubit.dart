import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lets_eat/data/models/settings.dart';
import 'package:lets_eat/helpers/background_service.dart';
import 'package:lets_eat/helpers/date_time.dart';
import 'package:lets_eat/helpers/shared_preferences.dart';

part 'settings_state.dart';

enum SettingKeys {
  notification;
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferencesHelper _sharedPrefHelper;

  SettingsCubit(this._sharedPrefHelper)
      : super(SettingsState(settings: Settings(notification: false)));

  Future<void> loadSettings() async {
    bool? notif =
        await _sharedPrefHelper.getBool(SettingKeys.notification.name);
    emit(
      SettingsState(
        settings: Settings(
          notification: notif ?? false,
        ),
      ),
    );
  }

  Future<void> setNotificationSettings(bool isEnabled) async {
    if (isEnabled) {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      await AndroidAlarmManager.cancel(1);
    }
    await _sharedPrefHelper.saveBool(SettingKeys.notification.name, isEnabled);
    loadSettings();
  }
}
