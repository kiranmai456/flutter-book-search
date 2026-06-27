import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:book_search_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:book_search_app/pages/formal/book_details_page_formal.dart';
import 'package:book_search_app/utils/utils.dart';
import 'package:book_search_app/widgets/stamp.dart';

class StampCollectionFormalPage extends StatefulWidget {
  const StampCollectionFormalPage({super.key});

  @override
  State<StampCollectionFormalPage> createState() =>
      _StampCollectionFormalPageState();
}

class _StampCollectionFormalPageState
    extends StampCollectionPageAbstractState<StampCollectionFormalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stamp Collection",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  "You have no collection yet",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : GridView.builder(
                itemCount: items.length,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final Book book = items[index];

                  return Stamp(
                    book.url,
                    width: 90,
                    onClick: () {
                      Navigator.of(context).push(
                        FadeRoute(
                          builder: (_) => BookDetailsPageFormal(book),
                          settings: const RouteSettings(
                            name: '/book_details_formal',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}