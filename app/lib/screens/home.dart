import 'package:dlxstudios_app/components/logo.dart';
import 'package:dlxstudios_app/state/state.dart';
import 'package:flavor_client/components/list.dart';
import 'package:flavor_client/components/tiles.dart';
import 'package:flavor_client/layout/FlavorResponsiveView.dart';
import 'package:flavor_client/layout/adaptive.dart';
import 'package:flavor_client/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:regex_router/src/route_args.dart';

class ScreenHome extends StatefulWidget {
  final RouteArgs? args;
  const ScreenHome({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final ScrollController _sc = ScrollController(keepScrollOffset: true);
  AppBar buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 80,
      leading: Container(
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //   width: 16,
            // ),
            LikeButton(
              likeBuilder: (l) => Icon(
                Icons.menu,
              ),
              onTap: (s) {
                GlobalScaffoldKey.currentState!.openDrawer();
                return Future.value(true);
              },
            ),
            Container(
              // color: Colors.amber,
              // height: 20,
              child: DLXLogo(
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('args::${widget.args}');
    return Scaffold(
      // appBar: buildMobileAppBar(context),
      body: FutureBuilder(
          future: FlavorFirestoreRepository()
              .firestore
              .collection('/media_published')
              .get()
              .then((value) => value.docs.map((e) => e.data()).toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var items = snapshot.data! as List;
              // print(items);

              return CustomScrollView(
                controller: _sc,
                slivers: [
                  buildSectionHorizontalList(
                    aspectRatio: 1,
                    children: fakeList2(items, aspectRatio: 1),
                    title: 'Recent',
                  ),
                  ...buildSectionGrid(
                    childAspectRatio: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 1,
                    children: fakeList2(items),
                    title: 'Space gadgets',
                  ),
                  buildSectionVerticalList(
                    children: fakeList2(items, aspectRatio: 1),
                    title: 'Rocket Fuel',
                  ),
                  buildSectionHorizontalList(
                    aspectRatio: .8,
                    children: fakeList2(items),
                    title: 'More Fire',
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  List<Widget> fakeList1(int count, {double aspectRatio = 1}) {
    return List.generate(
      count,
      (index) {
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: FlavorCardTile(
            onTap: () {},
            borderRadius: 4,
            // color: Colors.deepOrangeAccent,
          ),
        );
      },
    );
  }

  List<Widget> fakeList2(List items, {double aspectRatio = 1}) {
    return List.generate(
      items.length,
      (index) {
        print(items[index]);
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: FlavorCardTile(
            onTap: () {},
            borderRadius: 8,
            // color: Theme.of(context).cardColor,
            footerTitle: '${items[index]['title']}',
            footerSubtitle: '${items[index]['title']}',
            cardTileLayout: FlavorCardTileLayout.seperated,
            padding: EdgeInsets.all(4),
          ),
        );
      },
    );
  }

  SliverToBoxAdapter buildSectionHorizontalList({
    required List<Widget> children,
    required String title,
    double aspectRatio = 1.5,
  }) {
    return SliverToBoxAdapter(
      child: FlavorResponsiveView(
        global: false,
        breakpoints: {
          DisplayType.s: AspectRatio(
            aspectRatio: aspectRatio,
            child: FlavorTileSection(
              title: title,
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
          DisplayType.l: AspectRatio(
            aspectRatio: 3.7,
            child: FlavorTileSection(
              title: title,
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
        },
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
    double? maxCrossAxisExtent,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
    required double childAspectRatio,
    required int crossAxisCount,
  }) {
    var w = MediaQuery.of(context).size.width;
    return [
      SliverToBoxAdapter(
        child: FlavorTileHeader(
          title: title,
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(8),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: w > 600 ? 4 : crossAxisCount),
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
