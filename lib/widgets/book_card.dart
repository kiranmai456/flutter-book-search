import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onCardClick,
    required this.onStarClick,
  });

  final Book book;
  final VoidCallback onCardClick;
  final VoidCallback onStarClick;

  @override
  State<BookCard> createState() => BookCardState();
}

class BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardClick,
      child: Card(
        child: SizedBox(
          height: 200.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (widget.book.url != null)
                  Hero(
                    tag: widget.book.id,
                    child: Image.network(widget.book.url!),
                  ),

                const SizedBox(width: 10),

                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.book.title}    ${widget.book.notes}',
                            maxLines: 10,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            widget.book.starred
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          color: Colors.black,
                          onPressed: widget.onStarClick,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
