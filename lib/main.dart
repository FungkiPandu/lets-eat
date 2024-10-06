import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lets_eat/bloc/restaurant_favorites/restaurant_favorites_cubit.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/helpers/background_service.dart';
import 'package:lets_eat/helpers/database.dart';
import 'package:lets_eat/helpers/navigation.dart';
import 'package:lets_eat/helpers/notification.dart';
import 'package:lets_eat/screens/restaurant_detail_page.dart';
import 'package:lets_eat/screens/restaurant_favorites_page.dart';
import 'package:lets_eat/screens/restaurant_list_page.dart';
import 'package:lets_eat/screens/settings_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  final NotificationHelper notificationHelper = NotificationHelper();

  final BackgroundService service = BackgroundService();
  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  notificationHelper.requestAndroidPermissions(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class AppBlocObserver extends BlocObserver {
  /// {@macro app_bloc_observer}
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late final RestaurantFavoritesCubit restaurantFavoritesCubit;

  Future getNotificationDetailOnLaunch() async {
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final payload = details?.notificationResponse?.payload;
    if (payload == null) return;
    final restaurant = Restaurant.fromJson(jsonDecode(payload));
    Navigation.intentWithData(RestaurantDetailPage.routeName, restaurant);
  }

  @override
  void initState() {
    restaurantFavoritesCubit = RestaurantFavoritesCubit(_dbHelper);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getNotificationDetailOnLaunch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dbHelper.close(); // Close database when app is terminated
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _dbHelper.close(); // Close the database when app is in detached state
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => restaurantFavoritesCubit,
      child: MaterialApp(
        title: "Let's Eat!",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            primary: Colors.red.shade900,
          ),
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        initialRoute: RestaurantListPage.routeName,
        routes: {
          RestaurantListPage.routeName: (context) => const RestaurantListPage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurant:
                    ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
          RestaurantFavoritesPage.routeName: (context) =>
              const RestaurantFavoritesPage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
