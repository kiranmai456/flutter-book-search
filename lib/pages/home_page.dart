import 'package:book_search_app/model/book.dart';
import 'package:flutter/material.dart';

import 'package:book_search_app/data/repository.dart';
import 'package:book_search_app/model/Book.dart';
import 'package:book_search_app/utils/index_offset_curve.dart';
import 'package:book_search_app/widgets/collection_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController cardsFirstOpenController;

  String interfaceType = "formal";
  bool init = true;

  @override
  void initState() {
    super.initState();

    cardsFirstOpenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    Repository.get().init().then((_) {
      if (!mounted) return;
      setState(() {
        init = false;
      });
    });

    cardsFirstOpenController.forward(from: 0.2);
  }

  @override
  void dispose() {
    cardsFirstOpenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: init
          ? const SizedBox()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.pushNamed(context, '/search_$interfaceType');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.collections),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/stamp_collection_$interfaceType',
                        );
                      },
                    ),
                  ],
                  backgroundColor: Colors.white,
                  elevation: 2.0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  floating: true,
                  forceElevated: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    wrapInAnimation(myCollection(), 0),
                    wrapInAnimation(
                      collectionPreview(
                        const Color(0xffffffff),
                        "Biographies",
                        [
                          "wO3PCgAAQBAJ",
                          "_LFSBgAAQBAJ",
                          "8U2oAAAAQBAJ",
                          "yG3PAK6ZOucC",
                        ],
                      ),
                      1,
                    ),
                    wrapInAnimation(
                      collectionPreview(const Color(0xffffffff), "Fiction", [
                        "OsUPDgAAQBAJ",
                        "3e-dDAAAQBAJ",
                        "-ITZDAAAQBAJ",
                        "rmBeDAAAQBAJ",
                        "vgzJCwAAQBAJ",
                      ]),
                      2,
                    ),
                    wrapInAnimation(
                      collectionPreview(
                        const Color(0xffffffff),
                        "Mystery & Thriller",
                        ["1Y9gDQAAQBAJ", "Pz4YDQAAQBAJ", "UXARDgAAQBAJ"],
                      ),
                      3,
                    ),
                    wrapInAnimation(
                      collectionPreview(
                        const Color(0xffffffff),
                        "Science Fiction",
                        [
                          "JMYUDAAAQBAJ",
                          "PzhQydl-QD8C",
                          "nkalO3OsoeMC",
                          "VO8nDwAAQBAJ",
                          "Nxl0BQAAQBAJ",
                        ],
                      ),
                      4,
                    ),
                    Center(
                      child: Switch(
                        value: interfaceType != "formal",
                        onChanged: (value) {
                          setState(() {
                            interfaceType = value ? "material" : "formal";
                          });
                        },
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Magic Switch, press for different style",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }

  Widget wrapInAnimation(Widget child, int index) {
    final offsetAnimation = CurvedAnimation(
      parent: cardsFirstOpenController,
      curve: IndexOffsetCurve(index),
    );

    final fade = CurvedAnimation(parent: offsetAnimation, curve: Curves.ease);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0.0),
        end: Offset.zero,
      ).animate(fade),
      child: FadeTransition(opacity: fade, child: child),
    );
  }

  Widget collectionPreview(Color color, String name, List<String> ids) {
    return FutureBuilder<List<Book>>(
      future: Repository.get().getBooksByIdFirstFromDatabaseAndCache(ids),
      builder: (context, snapshot) {
        final books = snapshot.data ?? [];
        return CollectionPreview(
          books: books,
          color: color,
          title: name,
          loading: !snapshot.hasData,
        );
      },
    );
  }

  Widget myCollection() {
    return FutureBuilder<List<Book>>(
      future: Repository.get().getFavoriteBooks(),
      builder: (context, snapshot) {
        final books = snapshot.data ?? [];

        if (books.isEmpty) return const SizedBox();

        return CollectionPreview(
          books: books,
          color: const Color(0xffffffff),
          title: "My Collection",
          loading: !snapshot.hasData,
        );
      },
    );
  }
}
