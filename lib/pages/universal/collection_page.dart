import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:book_search_app/data/repository.dart';
import 'package:book_search_app/pages/universal/book_notes_page.dart';
import 'package:book_search_app/utils/utils.dart';
import 'package:book_search_app/widgets/book_card.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Book> _items = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Repository.get().getFavoriteBooks().then((books) {
      if (!mounted) return;

      setState(() {
        _items = books;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final book = _items[index];

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
          ],
        ),
      ),
    );
  }
}
