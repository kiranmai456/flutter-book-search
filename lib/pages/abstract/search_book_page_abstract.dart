import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:book_search_app/data/repository.dart';

abstract class AbstractSearchBookState<T extends StatefulWidget>
    extends State<T> {
  List<Book> items = <Book>[];

  final PublishSubject<String> subject = PublishSubject<String>();

  bool isLoading = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _textChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        isLoading = false;
        items.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
      items.clear();
    });

    Repository.get().getBooks(text).then((result) {
      if (!mounted) return;

      setState(() {
        isLoading = false;

        if (result.isOk()) {
          items = result.body;
        } else {
          scaffoldKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text(
                "Something went wrong, check your internet connection",
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    subject.stream
        .debounceTime(const Duration(milliseconds: 600))
        .listen(_textChanged);
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }
}
