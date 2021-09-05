import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlxstudios_app/app/player_scaffold.dart';
import 'package:dlxstudios_app/app/state.dart';
import 'package:dlxstudios_app/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_client/client/flavor_router.dart';
import 'package:flavor_client/client/flavor_state.dart';
import 'package:flavor_client/components/Page.dart';
import 'package:flavor_client/components/tiles.dart';
import 'package:flavor_client/layout/FlavorResponsiveView.dart';
import 'package:flavor_client/layout/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class DLXPageHome extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final FlavorClientState app = watch(dlxAppStateGlobal);

        if (app.isReady == false) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (app.userState == false) {
          /// !!! FIX !!! \\\
          return DLXPageOnboarding();
        }

        return PlayerScaffold(
          // controller: app.playerController,
          child: FlavorResponsiveView(
            breakpoints: {
              // fix list display from flavor page (firestore json page item)
              // DisplayType.s:
              //     DLXFlavorHomePage(app: app, drawer: _buildDrawer(app, context)),
              DisplayType.s: DLXHomeBody(),
              DisplayType.l: Row(
                children: [
                  Flexible(
                    flex: 0,
                    child: _buildDrawer(app, context),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(maxWidth: 240),
                      // child: FlavorPage.fromFsDocumentPath('/page_data/home'),
                      child: DLXHomeBody(),
                    ),
                  ),
                ],
              ),
            },
          ),
        );
        // return FutureBuilder<FlavorStoreItem>(
        //   // future: app.ss.search('', 'media_fs'),
        //   future: app.store.doc('/page_data/home'),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData &&
        //         snapshot.connectionState == ConnectionState.done) {
        //       print('snapshot.data.data::${snapshot.data!.data.toString()}');

        //       return FlavorPage(FlavorPageModel.formJson(snapshot.data!.data));
        //     }

        //     return Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // );

        // return FutureBuilder<FlavorStoreItem>(
        //     // future: app.ss.search('', 'media_fs'),
        //     // future: app.store.collection('media_published'),
        //     future: app.store.doc(''),
        //     builder: (context, snapshot) {
        //       switch (snapshot.connectionState) {
        //         case ConnectionState.none:
        //           return PageError();

        //         case ConnectionState.waiting:
        //         case ConnectionState.active:
        //           return Container(
        //             child: Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //           );

        //         case ConnectionState.done:
        //           break;

        //         default:
        //       }

        //       if (snapshot.hasError) {
        //         return PageError(
        //           errorCode: 505.toString(),
        //           msg: snapshot.error.toString(),
        //           title: 'Future return error',
        //           type: 'bad',
        //         );
        //       }

        //       FlavorPageModel page =
        //           FlavorPageModel.formJson(snapshot.data!.data);

        //       // print(
        //       //     'DLXPageHome::page.components!.length.toString()::${page.components!.length.toString()}');

        //       return FlavorPageView(
        //         // controller: _controller,
        //         children: List.generate(
        //           page.components!.length,
        //           (sectionIndex) {
        //             return AspectRatio(
        //               aspectRatio: 1,
        //               child: FlavorTileSection(
        //                 title: 'Section Title',
        //                 child: Container(
        //                   // padding: EdgeInsets.all(8),
        //                   // color: Colors.red,
        //                   child: FlavorList(
        //                     scrollDirection: Axis.horizontal,
        //                     itemCount: page.components!.length,
        //                     backgroundImage: sampleCover3,
        //                     headerTitle: 'Header Title',
        //                     headerSubtitle: 'header subtitle goes here',
        //                     footerTitle: 'Footer Title',
        //                     footerSubtitle: 'footoer subtitle',
        //                     footerLeading: Container(
        //                       color: Colors.indigo,
        //                     ),
        //                     headerLeading: Container(
        //                       color: Colors.indigo,
        //                     ),
        //                     footerTrailing: Container(
        //                       color: Colors.indigo,
        //                     ),
        //                     headerTrailing: Container(
        //                       color: Colors.indigo,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //       );
        //     });
      },
    );
  }

  _buildDrawer(FlavorClientState app, context) {
    Widget _header = Container(
      padding: EdgeInsets.all(16),
      height: 100,
      // color: Colors.green,
      child: Material(
          // elevation: 1.5,
          // color: Colors.amber.shade900,
          ),
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 280),
      child: ListView(
        children: [
          _header,
          ...app.routesForDrawer
              .map((e) => ListTile(
                    title: Text(e!.title!),
                    onTap: () {
                      // Navigator.of(context).pushNamed(e.path);
                      FlavorRouterDelegate.of(context).push(Uri(path: e.path));
                      // Router.of(context).routerDelegate.setNewRoutePath(Uri(path: e.path));
                    },
                  ))
              .toList()
        ],
      ),
    );
  }
}

class DLXHomeBody extends StatelessWidget {
  final ScrollController controller = ScrollController();

  DLXHomeBody({
    Key? key,
    ScrollController? controller,
  }) {
    if (controller != null) {}
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        // future: FlavorFirestoreRepository()
        // .firestore
        // .collection('/media_published')
        // .get()
        // .then((value) => value.docs.map((e) => e.data()).toList()),

        future: FirebaseFirestore.instance
            .collection('/media_published')
            .get()
            .then((value) => value.docs.map((e) => e.data()).toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('no data rn bro -_-'),
            );
          }

          // print("snapshot.data::${snapshot.data}");

          List<Map<String, dynamic>> items = snapshot.data!;

          return CustomScrollView(
            controller: controller,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) {
                    Widget body = Container();

                    Map<String, dynamic> itemData = items[i];

                    if (!itemData.containsKey('type')) {
                      return body;
                    }

                    String type = itemData['type'];

                    if (type == 'video') {
                      body = DLXVideoCard(itemData: itemData);
                    }

                    if (type == 'audio') {
                      body = DLXAudioCard(itemData: itemData);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: body,
                    );
                  },
                  childCount: items.length,
                ),
              )
            ],
          );
        });
  }
}

class DLXVideoCard extends StatefulWidget {
  const DLXVideoCard({
    Key? key,
    required this.itemData,
  }) : super(key: key);

  final Map<String, dynamic> itemData;

  @override
  _DLXVideoCardState createState() => _DLXVideoCardState();
}

class _DLXVideoCardState extends State<DLXVideoCard> {
  String? videoUrl;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    videoUrl = widget.itemData['videoUrl'];

    _controller = VideoPlayerController.network(videoUrl!)
      ..initialize().then((_) {
        // print('_controller.value.hasError::${_controller.value.hasError}');
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    // print(itemData['title']);

    if (_controller.value.hasError) {
      return AspectRatio(
        aspectRatio: 2,
        child: Container(
          child: Text('video is not available at this time'),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: FlavorCardTile(
        cardTileLayout: FlavorCardTileLayout.seperated,
        headerTitle: widget.itemData['title'],
        color: Colors.black,
        body: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller)),
        onTap: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DLXAudioCard extends StatelessWidget {
  const DLXAudioCard({
    Key? key,
    required this.itemData,
  }) : super(key: key);
  final Map<String, dynamic> itemData;

  @override
  Widget build(BuildContext context) {
    print(itemData);
    return AspectRatio(
      aspectRatio: 1.3,
      child: FlavorCardTile(
        cardTileLayout: FlavorCardTileLayout.seperated,
        headerTitle: itemData['title'],
        color: Colors.black,
        body: Container(),
        onTap: () {},
      ),
    );
  }
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
class DLXFlavorHomePage extends StatelessWidget {
  final Widget? drawer;

  const DLXFlavorHomePage({
    Key? key,
    required this.app,
    this.drawer,
  }) : super(key: key);

  final FlavorClientState app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer,
      body: FlavorPage.fromFsDocumentPath('/page_data/home'),
    );
  }
}
