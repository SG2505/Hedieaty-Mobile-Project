import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/AppUser.dart';
import '../Model/Event.dart';
import '../Model/Gift.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._internal();
  static Database? _database;

  factory LocalDB() => _instance;

  LocalDB._internal();

  /// Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Hedieaty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE AppUser(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phoneNumber TEXT NOT NULL,
        profilePictureUrl TEXT,
        preferences TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Event(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        userId TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Gift(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT,
        status TEXT NOT NULL,
        eventId INTEGER NOT NULL,
        FOREIGN KEY (eventId) REFERENCES Event (id)
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS AppUser');
    await db.execute('DROP TABLE IF EXISTS Event');
    await db.execute('DROP TABLE IF EXISTS Gift');
    await _onCreate(db, newVersion);
  }

  /// Reset the entire database
  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DELETE FROM AppUser');
    await db.execute('DELETE FROM Event');
    await db.execute('DELETE FROM Gift');
  }

  // ---------------- CRUD Functions ----------------

  // --------- AppUser CRUD ---------
  Future<void> insertUser(AppUser user) async {
    final db = await database;
    await db.insert('AppUser', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUser(AppUser user) async {
    final db = await database;
    await db.update('AppUser', user.toJson(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<AppUser?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('AppUser', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return AppUser.fromJson(maps.first);
    }
    return null;
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete('AppUser', where: 'id = ?', whereArgs: [id]);
  }

  // --------- Event CRUD ---------
  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert(
      'Event',
      {
        'name': event.name,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'description': event.description,
        'userId': event.userId,
        'status': event.status.toString().split('.').last,
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'Event',
      {
        'name': event.name,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'description': event.description,
        'userId': event.userId,
        'status': event.status.toString().split('.').last,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> getEventsByUserId(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Event', where: 'userId = ?', whereArgs: [userId]);
    return List.generate(
      maps.length,
      (i) => Event(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date']),
        location: maps[i]['location'],
        description: maps[i]['description'],
        userId: maps[i]['userId'],
        status: EventStatus.values.firstWhere(
          (e) => e.toString() == 'EventStatus.${maps[i]['status']}',
        ),
      ),
    );
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete('Event', where: 'id = ?', whereArgs: [id]);
  }

  // --------- Gift CRUD ---------
  Future<int> insertGift(Gift gift) async {
    final db = await database;
    return await db.insert(
      'Gift',
      {
        'name': gift.name,
        'description': gift.description,
        'category': gift.category,
        'price': gift.price,
        'imageUrl': gift.imageUrl,
        'status': gift.status.toString().split('.').last,
        'eventId': gift.eventId,
      },
    );
  }

  Future<void> updateGift(Gift gift) async {
    final db = await database;
    await db.update(
      'Gift',
      {
        'name': gift.name,
        'description': gift.description,
        'category': gift.category,
        'price': gift.price,
        'imageUrl': gift.imageUrl,
        'status': gift.status.toString().split('.').last,
        'eventId': gift.eventId,
      },
      where: 'id = ?',
      whereArgs: [gift.id],
    );
  }

  Future<List<Gift>> getGiftsByEventId(int eventId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Gift', where: 'eventId = ?', whereArgs: [eventId]);
    return List.generate(
      maps.length,
      (i) => Gift(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        description: maps[i]['description'],
        category: maps[i]['category'],
        price: maps[i]['price'],
        imageUrl: maps[i]['imageUrl'],
        status: GiftStatus.values.firstWhere(
          (e) => e.toString() == 'GiftStatus.${maps[i]['status']}',
        ),
        eventId: maps[i]['eventId'].toString(),
      ),
    );
  }

  Future<void> deleteGift(int id) async {
    final db = await database;
    await db.delete('Gift', where: 'id = ?', whereArgs: [id]);
  }
}
