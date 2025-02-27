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
    //users table//
    await db.execute('''
      CREATE TABLE Users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phoneNumber TEXT NOT NULL,
        profilePictureUrl TEXT,
        preferences TEXT,
        autoSync INT INTEGER NOT NULL DEFAULT 1
      )
    ''');
    //event table//
    await db.execute('''
      CREATE TABLE Events(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        userId TEXT NOT NULL,
        status TEXT NOT NULL,
        category TEXT NOT NULL,
        isPublished INTEGER NOT NULL DEFAULT 0
      )
    ''');
    //gift table//
    await db.execute('''
      CREATE TABLE Gifts(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT,
        status TEXT NOT NULL,
        eventId INTEGER NOT NULL,
        isPublished INTEGER NOT NULL DEFAULT 0,
        pledgerId TEXT,
        FOREIGN KEY (eventId) REFERENCES Events (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Friends(
        userId TEXT NOT NULL,
        friendId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        PRIMARY KEY (userId, friendId)
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('DROP TABLE IF EXISTS Events');
    await db.execute('DROP TABLE IF EXISTS Gifts');
    await db.execute('DROP TABLE IF EXISTS Friends');
    await _onCreate(db, newVersion);
  }

  /// Reset the entire database
  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('DROP TABLE IF EXISTS Events');
    await db.execute('DROP TABLE IF EXISTS Gifts');
    await db.execute('DROP TABLE IF EXISTS Friends');
  }

  Future<void> resetDatabase2() async {
    String path = join(await getDatabasesPath(), 'Hedieaty.db');
    await deleteDatabase(path);
    _database = null; // Clear the cached instance
  }

  // ---------------- CRUD Functions ----------------

  // --------- AppUser CRUD ---------
  Future<void> insertUser(AppUser user) async {
    final db = await database;
    await db.insert(
        'Users',
        {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'profilePictureUrl': user.profilePictureUrl,
          'autoSync': user.preferences['autoSync'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUser(AppUser user) async {
    final db = await database;
    await db.update(
        'Users',
        {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'profilePictureUrl': user.profilePictureUrl,
          'autoSync': user.preferences['autoSync'],
        },
        where: 'id = ?',
        whereArgs: [user.id]);
  }

  Future<AppUser?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return AppUser.fromJson(maps.first);
    }
    return null;
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  // --------- Event CRUD ---------
  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert(
      'Events',
      {
        'id': event.id,
        'name': event.name,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'description': event.description,
        'userId': event.userId,
        'status': event.status,
        'category': event.category,
        'isPublished': event.isPublished,
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'Events',
      {
        'id': event.id,
        'name': event.name,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'description': event.description,
        'userId': event.userId,
        'status': event.status,
        'category': event.category,
        'isPublished': event.isPublished,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> getEventsByUserId(String userId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('Events', where: 'userId = ?', whereArgs: [userId]);

    if (maps.isEmpty) {
      print('No events found for user: $userId');
      return [];
    }
    return List.generate(
      maps.length,
      (i) => Event.fromJson(maps[i]),
    );
  }

  Future<List<Event>> getUnpublishedEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Events', where: 'isPublished = ?', whereArgs: [0]);
    return List.generate(
      maps.length,
      (i) => Event.fromJson(maps[i]),
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete('Events', where: 'id = ?', whereArgs: [id]);
  }

  // --------- Gift CRUD ---------
  Future<int> insertGift(Gift gift) async {
    final db = await database;
    return await db.insert(
      'Gifts',
      {
        'id': gift.id,
        'name': gift.name,
        'description': gift.description,
        'category': gift.category,
        'price': gift.price,
        'imageUrl': gift.imageUrl,
        'status': gift.status,
        'eventId': gift.eventId,
        'isPublished': gift.isPublished,
        'pledgerId': gift.pledgerId,
      },
    );
  }

  Future<void> updateGift(Gift gift) async {
    final db = await database;
    await db.update(
      'Gifts',
      {
        'id': gift.id,
        'name': gift.name,
        'description': gift.description,
        'category': gift.category,
        'price': gift.price,
        'imageUrl': gift.imageUrl,
        'status': gift.status,
        'eventId': gift.eventId,
        'isPublished': gift.isPublished,
        'pledgerId': gift.pledgerId,
      },
      where: 'id = ?',
      whereArgs: [gift.id],
    );
  }

  Future<List<Gift>> getGiftsByEventId(String eventId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Gifts', where: 'eventId = ?', whereArgs: [eventId]);
    return List.generate(
      maps.length,
      (i) => Gift.fromJson(maps[i]),
    );
  }

  Future<List<Gift>> getUnpublishedGifts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Gifts', where: 'isPublished = ?', whereArgs: [0]);
    return List.generate(
      maps.length,
      (i) => Gift.fromJson(maps[i]),
    );
  }

  Future<void> deleteGift(String id) async {
    final db = await database;
    await db.delete('Gifts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteGiftsByEventId(String eventId) async {
    final db = await database;
    await db.delete('Gifts', where: 'eventId = ?', whereArgs: [eventId]);
  }

  // --------- Friends CRUD ---------

  // Insert a friend relationship (userId and friendId)
  Future<int> insertFriend(
      String userId, String friendId, String createdAt) async {
    final db = await database;
    return await db.insert(
        'Friends',
        {
          'userId': userId,
          'friendId': friendId,
          'createdAt': createdAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get friends by userId
  Future<List<String>> getFriendsByUserId(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Friends', where: 'userId = ?', whereArgs: [userId]);

    return List.generate(maps.length, (i) {
      return maps[i]['friendId'];
    });
  }

  // Delete a friend relationship (userId and friendId)
  Future<void> deleteFriend(String userId, String friendId) async {
    final db = await database;
    await db.delete('Friends',
        where: 'userId = ? AND friendId = ?', whereArgs: [userId, friendId]);
  }

  Future<String?> getLatestFriendshipCreatedAt(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Friends',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC', // Sort by createdAt in descending order
      limit: 1, // Fetch only the most recent record
    );

    if (maps.isNotEmpty) {
      return maps
          .first['createdAt']; // Return the 'createdAt' field as a String
    } else {
      return null; // No friendships found
    }
  }
}
