import 'package:book_search_app/model/book.dart';
import 'package:book_search_app/pages/formal/book_details_page_formal.dart';
import 'package:book_search_app/utils/utils.dart';
import 'package:book_search_app/widgets/stamp.dart';
import 'package:flutter/material.dart';

class CollectionPreview extends StatefulWidget {
  final List<Book> books;
  final Color color;
  final String title;
  final bool loading;

  const CollectionPreview({
    super.key,
    required this.title,
    required this.books,
    this.color = Colors.white,
    this.loading = false,
  });

  @override
  State<CollectionPreview> createState() => _CollectionPreviewState();
}

class _CollectionPreviewState extends State<CollectionPreview> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 32.0,
      fontFamily: 'CrimsonText',
      fontWeight: FontWeight.w400,
    );

    return ClipRect(
      child: Align(
        heightFactor: 0.7,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: 0.0,
            maxHeight: double.infinity,
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: widget.color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: textStyle),

                Stack(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.books.map((book) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Stamp(
                              book.url,
                              width: 100.0,
                              locked: !book.starred,
                              onClick: () {
                                Navigator.of(context).push(
                                  FadeRoute(
                                    builder: (BuildContext context) =>
                                        BookDetailsPageFormal(book),
                                    settings: const RouteSettings(
                                      name: '/book_details_formal',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    if (widget.loading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
