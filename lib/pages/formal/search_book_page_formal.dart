import 'package:flutter/material.dart';

import 'package:book_search_app/pages/abstract/search_book_page_abstract.dart';
import 'package:book_search_app/pages/formal/book_details_page_formal.dart';
import 'package:book_search_app/utils/utils.dart';
import 'package:book_search_app/widgets/book_card_compact.dart';

class SearchBookPageNew extends StatefulWidget {
  const SearchBookPageNew({super.key});

  @override
  State<SearchBookPageNew> createState() => _SearchBookStateNew();
}

class _SearchBookStateNew extends AbstractSearchBookState<SearchBookPageNew> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 35.0,
      fontFamily: 'Butler',
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            forceElevated: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),

                  const Text("Search for Books", style: textStyle),

                  const SizedBox(height: 16.0),

                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "What books did you read?",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onChanged: subject.add,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),

          if (isLoading)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),

          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final book = items[index];

              return BookCardCompact(
                book,
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
              );
            }, childCount: items.length),
          ),
        ],
      ),
    );
  }
}
