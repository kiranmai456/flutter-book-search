import 'package:flutter/material.dart';
import 'package:book_search_app/model/book.dart';


class BookCardMinimalistic extends StatelessWidget {



  const BookCardMinimalistic(this.book, {super.key});

  final Book book;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.network(book.url),
        ],
      ),
    );
  }

}