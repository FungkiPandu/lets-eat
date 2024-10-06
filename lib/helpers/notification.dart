import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/data/models/restaurants_response.dart';
import 'package:lets_eat/helpers/navigation.dart';
import 'package:lets_eat/screens/restaurant_detail_page.dart';

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          print('notification payload: $payload');
          final restaurant = Restaurant.fromJson(jsonDecode(payload));
          Navigation.intentWithData(RestaurantDetailPage.routeName, restaurant);
        }
      },
    );
  }

  void requestAndroidPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantsResponse restaurants) async {
    print("showNotification");

    var channelId = "1";
    var channelName = "recommendation";
    var channelDescription = "restaurant recommendation channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    Random rand = Random();
    int index = rand.nextInt(restaurants.restaurants.length);
    var titleNews = restaurants.restaurants[index].name;
    var titleNotification = "<b>$titleNews</b>";
    var bodyNotification = "Recommendation restaurant for you";

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      bodyNotification,
      platformChannelSpecifics,
      payload: json.encode(restaurants.restaurants[index].toJson()),
    );
  }
}
