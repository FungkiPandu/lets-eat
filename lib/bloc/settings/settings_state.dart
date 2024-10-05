part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final Settings settings;
  const SettingsState({required this.settings});
  @override
  List<Object> get props => [settings];
}
