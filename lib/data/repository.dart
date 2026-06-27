import 'dart:async';
import 'dart:convert';

import 'package:book_search_app/model/book.dart';
import 'package:http/http.dart' as http;
import 'package:book_search_app/data/database.dart';
import 'package:book_search_app/model/Book.dart';

class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isOk() => statusCode >= 200 && statusCode < 300;
}

const int NO_INTERNET = 404;

class Repository {
  static final Repository _repo = Repository._internal();

  late final BookDatabase database;

  Repository._internal() {
    database = BookDatabase.get();
  }

  static Repository get() => _repo;

  Future init() async {
    await database.init();
  }

  /// -------------------- GET BOOKS --------------------
  Future<ParsedResponse<List<Book>>> getBooks(String input) async {
    final uri = Uri.parse(
      "https://www.googleapis.com/books/v1/volumes?q=$input&langRestrict=en",
    );

    http.Response? response;

    try {
      response = await http.get(uri);
    } catch (_) {
      return ParsedResponse(NO_INTERNET, <Book>[]);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return ParsedResponse(response.statusCode, <Book>[]);
    }

    final data = jsonDecode(response.body);

    if (data['items'] == null) {
      return ParsedResponse(response.statusCode, <Book>[]);
    }

    final List<dynamic> list = data['items'];

    final Map<String, Book> networkBooks = {};

    for (final jsonBook in list) {
      final book = parseNetworkBook(jsonBook);
      networkBooks[book.id] = book;
    }

    final dbBooks = await database.getBooks(networkBooks.keys.toList());

    for (final book in dbBooks) {
      networkBooks[book.id] = book;
    }

    return ParsedResponse(response.statusCode, networkBooks.values.toList());
  }

  /// -------------------- GET SINGLE BOOK --------------------
  Future<ParsedResponse<Book?>> getBook(String id) async {
    final uri = Uri.parse("https://www.googleapis.com/books/v1/volumes/$id");

    http.Response? response;

    try {
      response = await http.get(uri);
    } catch (_) {
      return ParsedResponse(NO_INTERNET, null);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return ParsedResponse(response.statusCode, null);
    }

    final jsonBook = jsonDecode(response.body);

    Book book = parseNetworkBook(jsonBook);

    final dbBooks = await database.getBooks([book.id]);

    if (dbBooks.isNotEmpty) {
      book = dbBooks.first;
    }

    return ParsedResponse(response.statusCode, book);
  }

  /// -------------------- MULTIPLE BOOKS --------------------
  Future<List<Book>> getBooksById(List<String> ids) async {
    final List<Book> books = [];

    for (final id in ids) {
      final res = await getBook(id);
      if (res.body != null) {
        books.add(res.body as Book);
      }
    }

    return books;
  }

  /// -------------------- DB + NETWORK MIX --------------------
  Future<List<Book>> getBooksByIdFirstFromDatabaseAndCache(
    List<String> ids,
  ) async {
    final List<Book> books = [];
    final List<String> idsToFetch = List.from(ids);

    final dbBooks = await database.getBooks(ids);

    for (final b in dbBooks) {
      books.add(b);
      idsToFetch.remove(b.id);
    }

    for (final id in idsToFetch) {
      final uri = Uri.parse("https://www.googleapis.com/books/v1/volumes/$id");

      http.Response? response;

      try {
        response = await http.get(uri);
      } catch (_) {
        continue;
      }

      final jsonBook = jsonDecode(response.body);
      final book = parseNetworkBook(jsonBook);

      await updateBook(book);
      books.add(book);
    }

    return books;
  }

  /// -------------------- PARSER --------------------
  Book parseNetworkBook(dynamic jsonBook) {
    final volumeInfo = jsonBook["volumeInfo"] ?? {};

    final authors = volumeInfo["authors"];
    final author = (authors is List && authors.isNotEmpty)
        ? authors.first
        : "No author";

    final description = volumeInfo["description"] ?? "No description";

    final subtitle = volumeInfo["subtitle"] ?? "No subtitle";

    final imageLinks = volumeInfo["imageLinks"];

    return Book(
      id: jsonBook["id"] ?? "",
      title: volumeInfo["title"] ?? "No title",
      url: imageLinks != null ? imageLinks["smallThumbnail"] ?? "" : "",
      author: author,
      description: description,
      subtitle: subtitle,
    );
  }

  /// -------------------- DB OPS --------------------
  Future updateBook(Book book) async {
    await database.updateBook(book);
  }

  Future close() async {
    return database.close();
  }

  Future<List<Book>> getFavoriteBooks() {
    return database.getFavoriteBooks();
  }
}
