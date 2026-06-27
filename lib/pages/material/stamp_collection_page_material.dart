import 'package:flutter/material.dart';
import 'package:book_search_app/data/repository.dart';
import 'package:book_search_app/model/Book.dart';
import 'package:book_search_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:book_search_app/widgets/book_card_compact.dart';


class StampCollectionPage extends StatefulWidget {
  const StampCollectionPage({super.key});

  @override
  State<StatefulWidget> createState() => _StampCollectionPageState();

}


class _StampCollectionPageState extends StampCollectionPageAbstractState<StampCollectionPage> {

  @override
  Widget build(BuildContext context) {

    Matrix4 transform = Matrix4.skewX(10.0);
    transform.translate(-100.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stamp Collection"),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index){
        return BookCardCompact(items[index], onClick: (){},);
      },
      itemCount: items.length,
      ),
    );
  }


}