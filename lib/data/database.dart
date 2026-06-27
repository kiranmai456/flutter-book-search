import 'dart:io';

import 'package:book_search_app/model/book.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:book_search_app/model/Book.dart';

class BookDatabase {
  static final BookDatabase _bookDatabase = BookDatabase._internal();

  final String tableName = "Books";

  Database? _db;
  bool didInit = false;

  BookDatabase._internal();

  static BookDatabase get() => _bookDatabase;

  Future<Database> _getDb() async {
    if (!didInit || _db == null) {
      await _init();
    }
    return _db!;
  }

  Future<void> init() async {
    await _init();
  }

  Future<void> _init() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    final String path = join(documentsDirectory.path, "demo.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            ${Book.db_id} TEXT PRIMARY KEY,
            ${Book.db_title} TEXT,
            ${Book.db_url} TEXT,
            ${Book.db_star} INTEGER,
            ${Book.db_notes} TEXT,
            ${Book.db_author} TEXT,
            ${Book.db_description} TEXT,
            ${Book.db_subtitle} TEXT
          )
        ''');
      },
    );

    didInit = true;
  }

  /// ---------------- GET SINGLE BOOK ----------------
  Future<Book?> getBook(String id) async {
    final db = await _getDb();

    final result = await db.query(
      tableName,
      where: "${Book.db_id} = ?",
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return Book.fromMap(result.first);
  }

  /// ---------------- GET MULTIPLE BOOKS ----------------
  Future<List<Book>> getBooks(List<String> ids) async {
    final db = await _getDb();

    if (ids.isEmpty) return [];

    final placeholders = ids.map((_) => '?').join(',');

    final result = await db.rawQuery(
      'SELECT * FROM $tableName WHERE ${Book.db_id} IN ($placeholders)',
      ids,
    );

    return result.map((e) => Book.fromMap(e)).toList();
  }

  /// ---------------- FAVORITES ----------------
  Future<List<Book>> getFavoriteBooks() async {
    final db = await _getDb();

    final result = await db.query(
      tableName,
      where: "${Book.db_star} = ?",
      whereArgs: [1],
    );

    return result.map((e) => Book.fromMap(e)).toList();
  }

  /// ---------------- UPDATE BOOK ----------------
  Future<void> updateBook(Book book) async {
    final db = await _getDb();

    await db.insert(tableName, {
      Book.db_id: book.id,
      Book.db_title: book.title,
      Book.db_url: book.url,
      Book.db_star: book.starred ? 1 : 0,
      Book.db_notes: book.notes,
      Book.db_author: book.author,
      Book.db_description: book.description,
      Book.db_subtitle: book.subtitle,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// ---------------- CLOSE DB ----------------
  Future<void> close() async {
    final db = await _getDb();
    await db.close();
  }
}
