import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:book_search_app/data/repository.dart';
abstract class StampCollectionPageAbstractState<T extends StatefulWidget>
    extends State<T> {
  List<Book> items = <Book>[];

  @override
  void initState() {
    super.initState();

    Repository.get().getFavoriteBooks().then((books) {
      if (!mounted) return;

      setState(() {
        items = books;
      });
    });
  }
}
