import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'news.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Bookmarks (
        BookmarkID INTEGER PRIMARY KEY AUTOINCREMENT,
        UserID INTEGER,
        ArticleID INTEGER,
        CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
        FOREIGN KEY (ArticleID) REFERENCES NewsArticles(ArticleID) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Comments (
        CommentID INTEGER PRIMARY KEY AUTOINCREMENT,
        ArticleID INTEGER,
        UserID INTEGER,
        CommentText TEXT NOT NULL,
        CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (ArticleID) REFERENCES NewsArticles(ArticleID) ON DELETE CASCADE,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE NewsArticles (
        ArticleID INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Content TEXT NOT NULL,
        ImageUrl TEXT,
        AuthorID INTEGER,
        PublishedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (AuthorID) REFERENCES Users(UserID)
      )
    ''');

    await db.execute('''
      CREATE TABLE Users (
        UserID INTEGER PRIMARY KEY AUTOINCREMENT,
        Username TEXT NOT NULL UNIQUE,
        Role TEXT NOT NULL DEFAULT 'user' CHECK (Role IN ('user', 'admin')),
        Email TEXT NOT NULL UNIQUE,
        PasswordHash TEXT NOT NULL,
        CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  //crud insert tabel user
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('Users', user);
  }

  //buat insert bookmark
  Future<int> insertBookmark(Map<String, dynamic> bookmark) async {
    Database db = await database;
    return await db.insert('Bookmarks', bookmark);
  }

  //buat insert comment
  Future<int> insertComment(Map<String, dynamic> comment) async {
    Database db = await database;
    return await db.insert('Comments', comment);
  }

  //buat insert post news (articles)
  Future<int> insertNewsArticle(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('NewsArticles', row);
  }

  // READ/fetch operations
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    Database db = await database;
    return await db.query('Bookmarks');
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    Database db = await database;
    return await db.query('Comments');
  }

  Future<List<Map<String, dynamic>>> getNewsArticles() async {
    Database db = await database;
    return await db.query('NewsArticles');
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('Users');
  }

  // UPDATE operations
  Future<int> updateBookmark(int id, Map<String, dynamic> bookmark) async {
    Database db = await database;
    return await db.update(
      'Bookmarks',
      bookmark,
      where: 'BookmarkID = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateComment(int id, Map<String, dynamic> comment) async {
    Database db = await database;
    return await db.update(
      'Comments',
      comment,
      where: 'CommentID = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNewsArticle(int id, Map<String, dynamic> article) async {
    Database db = await database;
    return await db.update(
      'NewsArticles',
      article,
      where: 'ArticleID = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'Users',
      user,
      where: 'UserID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteComment(int id) async {
    Database db = await database;
    return await db.delete(
      'Comments',
      where: 'CommentID = ?',
      whereArgs: [id],
    );
  }

  //apus bookmark
  Future<int> deleteBookmark(int userId, int articleId) async {
    Database db = await database;
    return await db.delete(
      'Bookmarks',
      where: 'UserID = ? AND ArticleID = ?',
      whereArgs: [userId, articleId],
    );
  }

  //scary (yes its delete the entire database)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'news.db');
    await databaseFactory.deleteDatabase(path);
  }

  //delete news
  Future<int> deleteNewsArticle(int id) async {
    Database db = await database;
    return await db.delete(
      'NewsArticles',
      where: 'ArticleID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'Users',
      where: 'UserID = ?',
      whereArgs: [id],
    );
  }

  //cek apakah user telah bookmark news article nya
  Future<bool> isArticleBookmarked(int userId, int articleId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Bookmarks',
      where: 'UserID = ? AND ArticleID = ?',
      whereArgs: [userId, articleId],
    );
    return result.isNotEmpty;
  }

  //ambil news yang di bookmark oleh user saja.
  Future<List<Map<String, dynamic>>> getBookmarkedArticles(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Bookmarks',
      columns: ['ArticleID'],
      where: 'UserID = ?',
      whereArgs: [userId],
    );
    List<int> articleIds = maps.map((map) => map['ArticleID'] as int).toList();

    if (articleIds.isEmpty) return [];

    final articles = await db.query(
      'NewsArticles',
      where: 'ArticleID IN (${articleIds.join(', ')})',
    );

    return articles;
  }

  Future<void> registerUser(
      String username, String email, String password) async {
    String passwordHash = _generatePasswordHash(password);
    final db = await database;
    await db.insert('Users', {
      'Username': username,
      'Role': 'admin',
      'Email': email,
      'PasswordHash': passwordHash,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    Database db = await database;
    String passwordHash = _generatePasswordHash(password);
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'Email = ? AND PasswordHash = ?',
      whereArgs: [email, passwordHash],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  //password hashing buat register
  String _generatePasswordHash(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  //ambil data komentar dan usernamenya
  Future<List<Map<String, dynamic>>> getCommentsUsername(int articleId) async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT Comments.CommentID, Comments.CommentText, Users.Username 
    FROM Comments 
    JOIN Users ON Comments.UserID = Users.UserID 
    WHERE Comments.ArticleID = ? 
    ORDER BY Comments.CreatedAt DESC
  ''', [articleId]);
  }

  Future<Map<String, dynamic>?> getNewsArticleById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'NewsArticles',
      where: 'ArticleID = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
