import 'dart:async';

import 'package:lets_eat/data/models/restaurant.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DatabaseTable {
  restaurantFavorites("restaurant_favorites");

  const DatabaseTable(this.value);

  final String value;
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the database path
    String path = join(await getDatabasesPath(), 'lets-eat.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create table
  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${DatabaseTable.restaurantFavorites.value} (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
      ''',
    );
  }

  // Insert into database
  Future<int> insertFavRestaurant(Restaurant restaurant) async {
    final db = await database;
    return await db.insert(
      DatabaseTable.restaurantFavorites.value,
      restaurant.toJsonMinimum(),
    );
  }

  // Retrieve all favorites
  Future<List<Restaurant>> getAllFavRestaurants() async {
    final db = await database;
    return await db
        .query(DatabaseTable.restaurantFavorites.value)
        .then((res) => res
            .map(
              (r) => Restaurant.fromJson(r),
            )
            .toList());
  }

  // Update an favorite
  Future<int> updateFavRestaurant(String id, Restaurant restaurant) async {
    final db = await database;
    return await db.update(
        DatabaseTable.restaurantFavorites.value, restaurant.toJsonMinimum(),
        where: 'id = ?', whereArgs: [id]);
  }

  // Update an favorite
  Future<List<Map<String, Object?>>> getFavRestaurant(
      String restaurantId) async {
    final db = await database;
    return await db.query(
      DatabaseTable.restaurantFavorites.value,
      where: 'id = ?',
      whereArgs: [restaurantId],
      limit: 1,
    );
  }

  // Update an favorite
  Future<List<Map<String, Object?>>> searchFavRestaurant(String query) async {
    final db = await database;
    return await db.query(
      DatabaseTable.restaurantFavorites.value,
      where: 'name = %?%',
      whereArgs: [query],
    );
  }

  // Delete an favorite
  Future<int> deleteFavRestaurant(String id) async {
    final db = await database;
    return await db.delete(DatabaseTable.restaurantFavorites.value,
        where: 'id = ?', whereArgs: [id]);
  }

  // Clear all favorites
  Future<int> clearFavRestaurant() async {
    final db = await database;
    return await db.delete(DatabaseTable.restaurantFavorites.value);
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
