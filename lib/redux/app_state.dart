import 'package:book_search_app/model/book.dart';

class AppState {
  final List<Book> readBooks;

  AppState({required this.readBooks});

  static AppState initState() {
    return AppState(readBooks: []);
  }
}
