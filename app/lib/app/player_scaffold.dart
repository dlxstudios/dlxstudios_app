import 'package:dlxstudios_app/app/player_state.dart';
import 'package:flavor_client/models/media.dart';
import 'package:flavor_client/theme/clay/clay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class PlayerScaffold extends StatefulWidget {
  final Widget child;

  const PlayerScaffold({Key? key, required this.child}) : super(key: key);
  @override
  _PlayerScaffoldState createState() => _PlayerScaffoldState();
}

class _PlayerScaffoldState extends State<PlayerScaffold> {
  final _sc = ScrollController();

  void _scl;

  var playerMaxHeight = 300.0;

  double ratio = 0;
  double ratioReverse = 1;

  @override
  void initState() {
    super.initState();
    _scl = _sc.addListener(() {
      print(_sc.position);
      // print(_sc.position.viewportDimension);
      var _max = _sc.position.viewportDimension - 64;
      var _curr = _sc.position.pixels;
      var _ratio = ((_max * _curr) / _max) / _max;
      var _ratioReverse = ((_max - _curr) / _max) / _max * 1000;
      // print('_ratioReverse : $_ratioReverse');
      if (_ratio > .88) {
        _ratio = 1;
        _ratioReverse = 0;
      } else if (_ratio < .12) {
        _ratio = 0;
        _ratioReverse = 1;
      }
      // print(_ratio);

      // var newHeight = playerMaxHeight * _ratio;

      setState(() {
        ratio = _ratio;
        ratioReverse = _ratioReverse;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sc.removeListener(() => _scl);
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarHeight = 84.0;
    var playerAspectRatio = 9 / 16;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, size) {
          var height = size.maxHeight;
          var width = size.maxWidth;

          var playerAspectRatioWidth = playerAspectRatio * height;
          var playerAspectRatioHeight = width * playerAspectRatio;

          // print('Size \n Height : $height \n Width : $width');
          print(
              'Player Aspect Ratio \n playerAspectRatioWidth : $playerAspectRatioWidth \n playerAspectRatioHeight : $playerAspectRatioHeight');

          return CustomScrollView(
            controller: _sc,
            physics: PageScrollPhysics(),
            slivers: [
              // main body
              SliverToBoxAdapter(
                // Main Child
                child: Container(
                  height: (height - bottomBarHeight).toDouble(),
                  // color: Colors.amber,
                  // child: PageHome(
                  //   gridCrossCount: 2,
                  // ),
                  child: widget.child,
                ),
              ),
              // player mini
              SliverToBoxAdapter(
                child: Opacity(
                  opacity: 1,
                  child: NowPlayingMini(),
                ),
              ),
              // player video view
              SliverAppBar(
                elevation: 0,
                // pinned: true,
                expandedHeight: playerAspectRatioHeight,
                collapsedHeight: playerAspectRatioHeight,
                flexibleSpace: Opacity(
                  opacity: ratio,
                  child: PlayerVideoView(sc: _sc),
                ),
              ),
              // player large mobile

              SliverToBoxAdapter(
                child: NowPlayingMobile(
                  sc: _sc,
                  constraints: BoxConstraints(
                    minHeight: (900 - 220).toDouble(),
                  ),
                ),
              ),
              // SliverList(
              //   delegate: SliverChildListDelegate([
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundColor: Colors.blueGrey,
              //       ),
              //       title: Text('Title of Media'),
              //       subtitle: Text('Title of Media'),
              //     ),
              //   ]),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class PlayerVideoView extends StatelessWidget {
  const PlayerVideoView({
    Key? key,
    required ScrollController sc,
  })  : _sc = sc,
        super(key: key);

  final ScrollController _sc;

  @override
  Widget build(BuildContext context) {
    return PlayerConsumerBuilder((context, player) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          // color: Colors.deepOrange,
          image: player.currentTrack != null
              ? DecorationImage(
                  image: Image.network(player.currentTrack!.coverUrl.toString())
                      .image,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        // color: Colors.yellowAccent,
        child: Stack(
          children: [
            // Video Surface
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: player.currentTrack != null &&
                        player.videoPlayerController != null
                    ? VideoPlayer(player.videoPlayerController!)
                    : null,
              ),
            ),
            // Top buttons
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _sc.animateTo(
                                0,
                                curve: Curves.easeInOutQuart,
                                duration: Duration(milliseconds: 600),
                              );
                            },
                            icon: Transform.rotate(
                                angle: -1.6, child: Icon(Icons.arrow_back_ios)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.cast_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              player.togglePlaybackMode();
                            },
                            icon: player.playbackMode == PlaybackMode.none
                                ? Icon(CupertinoIcons.repeat)
                                : player.playbackMode == PlaybackMode.repeatAll
                                    ? Icon(
                                        CupertinoIcons.repeat,
                                        color: Theme.of(context).accentColor,
                                      )
                                    : Icon(
                                        CupertinoIcons.repeat_1,
                                        color: Theme.of(context).accentColor,
                                      ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // height: 60,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // player.currentTrack != null
                    //     ? Text([
                    //         if (player.videoPlayerController.value.position
                    //                 ?.inHours >
                    //             0)
                    //           player
                    //               .videoPlayerController.value.position.inHours,
                    //         player
                    //             .videoPlayerController.value.position.inMinutes,
                    //         player
                    //             .videoPlayerController.value.position.inSeconds
                    //       ]
                    //         .map((seg) =>
                    //             seg.remainder(60).toString().padLeft(2, '0'))
                    //         .join(':'))
                    // :
                    Text('00:00'),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        child: LinearProgressIndicator(
                          value: player.currentDuration,
                        ),
                      ),
                    ),
                    player.currentTrack != null && player.isLoading
                        ? Text([
                            if (player.videoPlayerController!.value.duration
                                    .inHours >
                                0)
                              player.videoPlayerController!.value.duration
                                  .inHours,
                            player.videoPlayerController!.value.duration
                                .inMinutes,
                            player
                                .videoPlayerController!.value.duration.inSeconds
                          ]
                            .map((seg) =>
                                seg.remainder(60).toString().padLeft(2, '0'))
                            .join(':'))
                        : Text('00:00'),
                    IconButton(
                      onPressed: () {
                        _sc.animateTo(
                          0,
                          curve: Curves.easeInOutQuart,
                          duration: Duration(milliseconds: 600),
                        );
                      },
                      icon: Icon(Icons.fullscreen_outlined),
                    ),
                  ],
                ),
              ),
            ),

            // Center Buttons
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                // height: (64 + 64).toDouble(),
                // padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_arrow_outlined,
                      ),
                      iconSize: 64,
                      splashRadius: 32,
                    ),
                  ],
                ),
              ),
            ),

            // player actions
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                // child: player.currentTrack != null &&
                //         player.videoPlayerController != null
                //     ? VideoPlayer(player.videoPlayerController)
                //     : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class NowPlayingMobile extends StatelessWidget {
  const NowPlayingMobile({
    Key? key,
    required ScrollController sc,
    this.constraints,
  })  : _sc = sc,
        super(key: key);

  // ignore: unused_field
  final ScrollController _sc;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return PlayerConsumerBuilder((context, player) {
      return Material(
        child: Container(
          // color: Colors.red,
          // margin: EdgeInsets.only(top: 82),
          constraints: constraints,
          child: ListView(
            shrinkWrap: true,
            // controller: _sc,
            children: [
              player.currentTrack != null
                  ? ListTile(
                      leading: Container(
                        width: 56,
                        height: 56,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.purple,
                          // image: DecorationImage(
                          //     image: Image.network(sampleCover3).image),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 90,
                          // backgroundImage: Image.network(sampleCover3).image,
                        ),
                      ),
                      title: Text(
                        '${player.currentTrack?.title}',
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        '${player.currentTrack?.title}',
                        maxLines: 1,
                      ),
                    )
                  : Container(),
              player.currentTrack != null
                  ? Container(
                      margin: EdgeInsets.only(top: 28, left: 16, right: 16),
                      child: Text(
                        'Description if it be not null. Title of the Media. Title of the Media. Title of the Media. Title of the Media.',
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
              player.currentTrack != null
                  ? Container(
                      margin: EdgeInsets.only(top: 16, left: 16, right: 34),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                ClayContainer(
                                  depth: 4,
                                  borderRadius: 16,
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      '#Lo-Fi',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      // .copyWith(fontSize: 18),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ).toList(),
                      ),
                    )
                  : Container(),
              // BottomAppBar(
              //   child: Container(
              //     height: 60,
              //     child: Row(),
              //   ),
              // ),
              player.currentTrack != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.max,
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_up_outlined),
                              ),
                              Text('${player.currentTrack?.likeCount}'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_down_outlined),
                              ),
                              Text('data'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.save_alt_outlined),
                              ),
                              Text('data'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.share_outlined),
                              ),
                              Text('data'),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                // color: Colors.red,
                // height: 900,
                child: Container(
                  // height: 200,
                  margin: EdgeInsets.symmetric(vertical: 16),

                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Material(
                    color: Theme.of(context).accentColor.withOpacity(.02),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              // margin: EdgeInsets.only(top: 8),
                              child: ClayContainer(
                                depth: 3,
                                height: 10,
                                width: 100,
                                borderRadius: 16,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Up Next',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .color,
                                        ),
                                    maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon:
                                //       Icon(Icons.add_to_home_screen),
                                // ),
                              ],
                            ),
                          ),
                          ...buildNowPlayingPlayListItems(
                              context, player.currentPlaylist!)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NowPlayingMini extends StatelessWidget {
  const NowPlayingMini({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayerConsumerBuilder((context, player) {
      return Material(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 82,
          // color: Colors.green,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: Container(
                  color: Colors.black12,
                  child: player.currentTrack != null
                      ? VideoPlayer(player.videoPlayerController!)
                      : Container(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      player.currentTrack != null
                          ? Text(
                              '${player.currentTrack!.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Container(),
                      Text('Now Playing'),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: player.currentTrack != null
                        ? () {
                            // print('playPause!');
                            player.playPause();
                          }
                        : null,
                    icon: Icon(player.isPlaying
                        ? Icons.pause_outlined
                        : Icons.play_arrow_outlined),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

class PlayerConsumerBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, PlayerState playerState) builder;

  PlayerConsumerBuilder(this.builder);

  @override
  Widget build(BuildContext context, watch) {
    final state = watch(playerStateProvider);
    return builder(context, state);
  }
}

buildNowPlayingPlayListItems(BuildContext context, List<Track> tracks) {
  return List.generate(
    tracks.length,
    (index) => Container(
      // color: Colors.red,
      height: 76,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // image: DecorationImage(
              //   image: Image.network(sampleCover3).image,
              // ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              child: AspectRatio(
                aspectRatio: 1.6,
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              // width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '{state.currentTrack.title}',
                    // style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'data',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
