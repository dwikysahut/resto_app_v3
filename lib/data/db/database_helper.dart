import 'package:resto_app/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }
  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();
  static const String _tblRestaurant = "restaurant";

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase('$path/restaurantapp.db', onCreate: (db, _) async {
      await db.execute('''CREATE TABLE $_tblRestaurant (
             id TEXT PRIMARY KEY,
             name TEXT,
             title TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating DOUBLE
           )     
        ''');
    }, version: 1);
    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }
    return _database;
  }

  Future<void> insertToFavorite(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblRestaurant, restaurant.toJson());
  }

  Future<List<Restaurant>> getFavoriteRestaurants() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblRestaurant);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getRestaurantById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tblRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeRestaurantById(String id) async {
    final db = await database;
    await db!.delete(_tblRestaurant, where: 'id = ?', whereArgs: [id]);
  }
}
