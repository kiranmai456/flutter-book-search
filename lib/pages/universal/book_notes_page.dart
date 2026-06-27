import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:book_search_app/data/repository.dart';

class BookNotesPage extends StatefulWidget {
  const BookNotesPage(this.book, {super.key});

  final Book book;

  @override
  State<BookNotesPage> createState() => _BookNotesPageState();
}

class _BookNotesPageState extends State<BookNotesPage> {
  late final TextEditingController _textController;

  final PublishSubject<String> subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.book.notes);

    subject.stream.debounceTime(const Duration(milliseconds: 400)).listen((
      text,
    ) {
      widget.book.notes = text;
      Repository.get().updateBook(widget.book);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Hero(tag: book.id, child: Image.network(book.url)),

            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    maxLines: null,
                    controller: _textController,
                    onChanged: subject.add,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
