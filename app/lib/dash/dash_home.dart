import 'package:flavor_client/components/list.dart';
import 'package:flavor_client/components/tiles.dart';
import 'package:flavor_client/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashHome extends StatefulWidget {
  const DashHome({
    Key? key,
  }) : super(key: key);

  @override
  _DashHomeState createState() => _DashHomeState();
}

class _DashHomeState extends State<DashHome> {
  final ScrollController _sc = ScrollController(keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: FutureBuilder(
            future: FlavorFirestoreRepository()
                .firestore
                .collection('/media_published')
                .get()
                .then((value) => value.docs.map((e) => e.data()).toList()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var items = snapshot.data!;
                // print(items);
                return CustomScrollView(
                  controller: _sc,
                  slivers: [
                    buildSectionHorizontalList(
                      children: fakeList1(5),
                      title: 'Recent',
                    ),
                    ...buildSectionGrid(
                      childAspectRatio: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      maxCrossAxisExtent: 200,
                      children: fakeList1(6),
                      title: 'Space gadgets',
                    ),
                    buildSectionVerticalList(
                      children: fakeList1(2),
                      title: 'Rocket Fuel',
                    ),
                    buildSectionHorizontalList(
                      children: fakeList1(50),
                      title: 'Recent',
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  List<Widget> fakeList1(int count) {
    return List.generate(
      count,
      (index) {
        return AspectRatio(
          aspectRatio: 1.6,
          child: FlavorCardTile(
            onTap: () {},
            borderRadius: 16,
            color: Colors.deepOrangeAccent,
          ),
        );
      },
    );
  }

  SliverToBoxAdapter buildSectionHorizontalList({
    required List<Widget> children,
    required String title,
  }) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 2,
        child: FlavorTileSection(
          title: 'Recent',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              controller: _sc,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionVerticalList({
    required List<Widget> children,
    required String title,
  }) {
    children.insert(
      0,
      FlavorTileHeader(
        title: title,
      ),
    );

    return SliverPadding(
      padding: EdgeInsets.all(8),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          children,
        ),
      ),
    );
  }

  List<Widget> buildSectionGrid({
    required List<Widget> children,
    required String title,
    required double maxCrossAxisExtent,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
    required double childAspectRatio,
  }) {
    return [
      SliverToBoxAdapter(
        child: FlavorTileHeader(
          title: title,
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(8),
        sliver: SliverGrid(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return children[index];
            },
            childCount: children.length,
          ),
        ),
      )
    ];
  }
}
