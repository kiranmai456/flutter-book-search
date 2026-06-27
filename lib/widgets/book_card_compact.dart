import 'package:flutter/material.dart';
import 'package:book_search_app/model/book.dart';

class BookCardCompact extends StatelessWidget {
  const BookCardCompact(this.book, {super.key, required this.onClick});

  final Book book;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: book.id,
                  child: Image.network(
                    book.url,
                    height: 150.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4.0),
                        Text(book.author),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16.0),
              ],
            ),
            const Divider(color: Colors.black38, indent: 128.0),
          ],
        ),
      ),
    );
  }

  /// Optional helper (kept for future use)
  String shortText(String title, int targetLength) {
    final words = title.split(" ");
    int length = 0;
    String result = "";
    bool showedAll = true;

    for (final word in words) {
      if (length + word.length <= targetLength) {
        length += word.length;
        result += "$word ";
      } else {
        showedAll = false;
        break;
      }
    }

    if (result.isEmpty && title.length > 18) {
      result = title.substring(0, 18);
      showedAll = false;
    }

    if (!showedAll) result += "...";
    return result.trim();
  }
}
