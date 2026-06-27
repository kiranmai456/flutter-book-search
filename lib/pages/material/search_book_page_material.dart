import 'package:flutter/material.dart';

import 'package:book_search_app/data/repository.dart';
import 'package:book_search_app/pages/abstract/search_book_page_abstract.dart';
import 'package:book_search_app/pages/universal/book_notes_page.dart';
import 'package:book_search_app/model/Book.dart';
import 'package:book_search_app/utils/utils.dart';
import 'package:book_search_app/widgets/book_card.dart';

class SearchBookPage extends StatefulWidget {
  const SearchBookPage({super.key});

  @override
  State<SearchBookPage> createState() => _SearchBookState();
}

class _SearchBookState extends AbstractSearchBookState<SearchBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("Book Search")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Choose a book'),
              onChanged: subject.add,
            ),

            const SizedBox(height: 8),

            if (isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final book = items[index];

                  return BookCard(
                    book: book,
                    onCardClick: () {
                      Navigator.of(context).push(
                        FadeRoute(
                          builder: (context) => BookNotesPage(book),
                          settings: const RouteSettings(name: '/notes'),
                        ),
                      );
                    },
                    onStarClick: () {
                      setState(() {
                        book.starred = !book.starred;
                      });

                      Repository.get().updateBook(book);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
