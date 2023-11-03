import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:employee_forums/screens/homepage/models/post_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'posts_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create your database tables here
        await db.execute('''
          CREATE TABLE posts (
            _id TEXT ,
            userId TEXT,
            description TEXT,
            title TEXT,
            image TEXT,
            tags TEXT,  -- Store tags as JSON strings
            likedUsers TEXT,  -- Store likedUsers as JSON strings
            eventCategory TEXT,
            eventStartAt TEXT,
            createdAt TEXT,
            eventEndAt TEXT,
            eventId TEXT,
            registration INTEGER,  -- Store registration as an integer (0 or 1)
            eventDescription TEXT,
            likes INTEGER,
            noOfComments INTEGER,
            comments TEXT  -- Store comments as JSON strings
          )
        ''');
      },
    );
  }

  Future<int> insertPost(Map<String, dynamic> post) async {
    final db = await database;
    PostModel data=await PostModel.fromJson(post);
    try {
      return await db.insert('posts', {
        '_id': data.id,
        'userId': data.userId,
        'description': data.description,
        'title': data.title,
        'image': jsonEncode(data.image),
        'tags': jsonEncode(data.tags),
        // Convert the list of tags to a JSON string
        'likedUsers': jsonEncode(data.likedUsers),
        // Convert the list of liked users to a JSON string
        'eventCategory': data.eventCategory,
        'eventStartAt': data.eventStartAt?.toString(),
        'eventEndAt': data.eventEndAt?.toString(),
        'eventId': data.eventId,
        'registration': data.registration.toString(),
        // Convert the boolean to a string
        'eventDescription': data.eventDescription,
        'likes': data.likes,
        'noOfComments': data.noOfComments,
        'comments': jsonEncode(data.comments),
        // Convert the list of comments to a JSON string
        'createdAt': data.createdAt?.toIso8601String(),
      });
    }catch(e){
      log(e.toString());
      rethrow;
    }

  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await database;
    return await db.query('posts');
  }
}
