import 'package:flutter/material.dart';
import 'package:book_search_app/pages/universal/collection_page.dart';
import 'package:book_search_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:book_search_app/pages/home_page.dart';
import 'package:book_search_app/pages/material/search_book_page_material.dart';
import 'package:book_search_app/pages/formal/search_book_page_formal.dart';
import 'package:book_search_app/pages/material/stamp_collection_page_material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:book_search_app/redux/app_state.dart';
import 'package:book_search_app/redux/reducers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<AppState> store = Store(
    readBookReducer,
    initialState: AppState.initState(),
  );

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Book search',
        theme: ThemeData(primaryColor: const Color(0xFF0F2533)),
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/search_material': (BuildContext context) => SearchBookPage(),
          '/search_formal': (BuildContext context) => SearchBookPageNew(),
          '/collection': (BuildContext context) => CollectionPage(),
          '/stamp_collection_material': (BuildContext context) =>
              StampCollectionPage(),
          '/stamp_collection_formal': (BuildContext context) =>
              StampCollectionFormalPage(),
        },
      ),
    );
  }
}
