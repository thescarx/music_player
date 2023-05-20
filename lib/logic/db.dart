import 'package:sqflite/sqflite.dart';

class Song {
  final int id;
  final String title;
  final String name;
  final String artist;
  final String uri;
  // ... other song properties

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.name,
    required this.uri,
  });
}

// 2. Set up a database (using the sqflite package)

class FavoritesDatabase {
  static const String dbName = 'favorites.db';
  static const String tableName = 'favorites';

  late Database _database;

  Future<void> open() async {
    _database = await openDatabase(
      dbName,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            title TEXT,
            artist TEXT,
            uri TEXT
          )
        ''');
      },
    );
    print('databse created');
  }

  Future<void> addFavorite(Song song) async {
    await _database.insert(tableName, {
      'id': song.id,
      'name': song.name,
      'title': song.title,
      'artist': song.artist,
      'uri': song.uri
    });
  }

  Future<void> removeFavorite(int id) async {
    await _database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

Future<bool> isElementExists(int id) async {

    // Query the database to check if the element exists
    List<Map<String, dynamic>> result = await _database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    // Return true if the element exists, false otherwise
    return result.isNotEmpty;
  }


  Future<List<Song>> getFavorites() async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);
    print(maps);
    return List.generate(maps.length, (index) {
      return Song(
          id: maps[index]['id'],
          name: maps[index]['name'],
          title: maps[index]['title'],
          artist: maps[index]['artist'],
          uri: maps[index]['uri']);
    });
  }
}
