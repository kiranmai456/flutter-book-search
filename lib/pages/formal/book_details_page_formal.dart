import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:book_search_app/data/repository.dart';
import 'package:book_search_app/pages/abstract/book_details_page_abstract.dart';
import 'package:book_search_app/widgets/icon_button_text.dart';

class BookDetailsPageFormal extends StatefulWidget {
  const BookDetailsPageFormal(this.book, {super.key});

  final Book book;

  @override
  State<BookDetailsPageFormal> createState() => _BookDetailsPageFormalState();
}

class _BookDetailsPageFormalState
    extends AbstractBookDetailsPageState<BookDetailsPageFormal> {
  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stamp Collection"),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: book.id,
                child: Image.network(
                  book.url,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontFamily: "CrimsonText"),
            ),

            const SizedBox(height: 8),

            Text(
              "${book.author} - Science Fiction",
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "CrimsonText",
                fontWeight: FontWeight.w400,
              ),
            ),

            const Divider(height: 32, color: Colors.black38),

            Row(
              children: [
                Expanded(
                  child: IconButtonText(
                    onClick: () {},
                    iconData: Icons.store,
                    text: "Search store",
                    selected: false,
                  ),
                ),
                Expanded(
                  child: IconButtonText(
                    onClick: () {
                      Clipboard.setData(ClipboardData(text: book.id));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied: "${book.id}"')),
                      );
                    },
                    iconData: Icons.bookmark,
                    text: "Bookmark",
                    selected: false,
                  ),
                ),
                Expanded(
                  child: IconButtonText(
                    onClick: () {
                      setState(() {
                        book.starred = !book.starred;
                      });
                      Repository.get().updateBook(book);
                    },
                    iconData: book.starred ? Icons.remove : Icons.add,
                    text: book.starred ? "Remove" : "Mark as read",
                    selected: book.starred,
                  ),
                ),
              ],
            ),

            const Divider(height: 32, color: Colors.black38),

            const Text(
              "Description",
              style: TextStyle(fontSize: 20, fontFamily: "CrimsonText"),
            ),

            const SizedBox(height: 8),

            Text(book.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
