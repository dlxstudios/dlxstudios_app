import 'package:flavor_client/client/flavor_router.dart';
import 'package:flavor_client/components/grid.dart';
import 'package:flavor_client/components/page.dart';
import 'package:flavor_client/components/tiles.dart';
import 'package:flavor_client/models/section.dart';
import 'package:flavor_client/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

/// Page : DLXInbox
///
/// !!! Todo : Combine inbox and groups
/// !!! Todo : replace groups with feature request
class ScreenInbox extends StatelessWidget {
  const ScreenInbox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageShell(
      statusbarColor: Colors.transparent,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  // icon: Icon(Icons.directions_car),
                  // text: 'Inbox',
                  child: Container(
                    // width: 10,
                    // height: 10,
                    child: Text('Inbox'),
                  ),
                ),
                Tab(
                  // icon: Icon(Icons.directions_transit),
                  text: 'Groups',
                ),
                // Tab(
                //   // icon: Icon(Icons.directions_bike),
                //   text: 'Calls',
                // ),
              ],
            ),
            backgroundColor: Colors.transparent,
            // backgroundColor: Theme.of(context).accentColor,
            elevation: 0,
            centerTitle: true,
            title: Container(
                // width: 90,
                child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.search_rounded),
              label: Text('Search'),
            )),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/account/add');
              },
              icon: Icon(Icons.qr_code_scanner_outlined),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/inbox/new');
                },
                icon: Icon(Icons.mode_edit_rounded),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings/chat');
                },
                icon: Icon(Icons.settings_rounded),
              )
            ],
          ),
          body: TabBarView(
            children: [
              InboxView(),
              GroupsView(),
              // Container(
              //   color: Colors.red,
              //   child: Center(
              //     child: SvgPicture.asset('assets/images/logo.2021.svg'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupsView extends StatelessWidget {
  GroupsView({
    Key? key,
  }) : super(key: key);

  final List<DataItem> _postFeed = List.generate(
    15,
    (index) => DataItem(
      {
        'title': '$index Item Title ',
        'type': index.isEven ? 'video' : 'image',
        'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
        'cover': 'https://source.unsplash.com/collection/$index/1500x1500',
        'comments': [
          {
            'title': '$index Item Title ',
            'type': index.isEven ? 'video' : 'image',
            'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
            'cover':
                'https://source.unsplash.com/collection/${index + 800}/50x50',
          }
        ],
        'caption': {
          'text': 'This is the caption of the post',
          'type': index.isEven ? 'video' : 'image',
          'cover':
              'https://source.unsplash.com/collection/${index + 400}/50x50',
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FlavorPageView(
      children: List.generate(
        _postFeed.length,
        (index) => ListTile(
          // minVerticalPadding: 24,
          leading: CircleAvatar(
            backgroundImage:
                Image.network(_postFeed[index].data['caption']['cover']).image,
          ),
          title: Text("Title of group"),
          subtitle: Text(
            '14 members include SpaM369, Franklining, LetgoMyEggo420',
            style: Theme.of(context).textTheme.caption,
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(24)),
                  child: Center(child: Text('1')),
                ),
              ),
              Text('4 minutes ago'),
            ],
          ),
        ),
      ),
    );
  }
}

class InboxView extends StatelessWidget {
  InboxView({
    Key? key,
  }) : super(key: key);

  final List<DataItem> _postFeed = List.generate(
    15,
    (index) => DataItem(
      {
        'title': '$index Item Title ',
        'type': index.isEven ? 'video' : 'image',
        'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
        'cover': 'https://source.unsplash.com/collection/$index/1500x1500',
        'comments': [
          {
            'title': '$index Item Title ',
            'type': index.isEven ? 'video' : 'image',
            'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
            'cover':
                'https://source.unsplash.com/collection/${index + 800}/50x50',
          }
        ],
        'caption': {
          'text': 'This is the caption of the post',
          'type': index.isEven ? 'video' : 'image',
          'cover':
              'https://source.unsplash.com/collection/${index + 400}/50x50',
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FlavorPageView(
      children: List.generate(
        _postFeed.length,
        (index) => ListTile(
          minVerticalPadding: 24,
          leading: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  // padding: const EdgeInsets.all(2.4),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  padding: const EdgeInsets.all(2.4),
                  child: CircleAvatar(
                    foregroundImage:
                        Image.network(_postFeed[index].data['caption']['cover'])
                            .image,
                  ),
                ),
              ],
            ),
          ),
          title: Text("This is the last message we didn't get to see yet."),
          subtitle: Text('sirskii'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(24)),
                  child: Center(child: Text('1')),
                ),
              ),
              Text('4 minutes ago'),
            ],
          ),
        ),
      ),
    );
  }
}

class DLXPageHomeWorking extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  final List<DataItem> _postFeed = List.generate(
    15,
    (index) => DataItem(
      {
        'title': '$index Item Title ',
        'type': index.isEven ? 'video' : 'image',
        'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
        'cover': 'https://source.unsplash.com/collection/$index/1500x1500',
        'comments': [
          {
            'title': '$index Item Title ',
            'type': index.isEven ? 'video' : 'image',
            'author': index.isOdd ? 'SirSkii' : 'BluntWrap',
            'cover':
                'https://source.unsplash.com/collection/${index + 800}/50x50',
          }
        ],
        'caption': {
          'text': 'This is the caption of the post',
          'type': index.isEven ? 'video' : 'image',
          'cover':
              'https://source.unsplash.com/collection/${index + 400}/50x50',
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        // final FlavorClientState app = watch(dlxAppStateGlobal);
        return PageShell(
          // safeArea: true,
          child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   actions: [
            //     IconButton(
            //       onPressed: () {
            //         FlavorRouterDelegate.of(context)
            //             .push(Uri(path: '/inbox/new'));
            //       },
            //       icon: Icon(Icons.mode_edit_rounded),
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     // IconButton(
            //     //   onPressed: () {
            //     //     Navigator.of(context).pushNamed('/settings/chat');
            //     //   },
            //     //   icon: Icon(Icons.person),
            //     // )
            //     //
            //     CircleAvatar(),
            //     SizedBox(
            //       width: 16,
            //     )
            //   ],
            // ),
            body: SingleChildScrollView(
              controller: _controller,
              child: FlavorLayoutGrid(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                borderRadius: 0,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                controller: _controller,
                crossAxisCount: 1,
                tileCardLayout: FlavorCardTileLayout.stacked,
                onFooter: (index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Spacer(),
                          DLXLikeButton(),
                          Spacer(),
                          DLXAddButton(),
                          Spacer(),
                          DLXShareButton(),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Colors.amber,
                        backgroundColor: Colors.green,
                        backgroundImage: Image.network(
                                _postFeed[index].data['caption']['cover'])
                            .image,
                      ),
                      title:
                          Text('${_postFeed[index].data['caption']['text']}'),
                      subtitle: Text('${_postFeed[index].data['author']}'),
                    ),
                    ListTile(
                      title: ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                        ),
                        title: Text(
                          'this is a hard as post bro, like on god',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_up_sharp,
                            size: 16,
                          ),
                        ),
                      ),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          labelText: 'comment',
                          alignLabelWithHint: true,
                          suffix: LikeButton(
                            isLiked: true,
                            onTap: (isLiked) {
                              return Future.value(true);
                            },
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                !isLiked
                                    ? Icons.send_outlined
                                    : Icons.send_rounded,
                                color: Colors.grey,
                                // size: buttonSize,
                              );
                            },
                          ),
                        ),
                        autofocus: false,
                      ),
                    ),
                  ],
                ),

                // onHeader: (index) => ListTile(
                //   leading: CircleAvatar(),
                //   title: Text('${_postFeed[index].data['title']}'),
                // ),
                onbackgoundImage: (index) => DecorationImage(
                  image:
                      Image.network('${_postFeed[index].data['cover']}').image,
                  fit: BoxFit.cover,
                ),
                itemCount: _postFeed.length,
                // itemBuilder: (context, index) => Material(),
                onBody: (index) => GestureDetector(
                  onTap: () => context.pushNamed('path'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image:
                            Image.network('${_postFeed[index].data['cover']}')
                                .image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // onBody: (index) => Container(
                //     // color: Colors.amber,
                //     ),
                onTap: (index) {
                  print('item #$index');
                  // app.currentPages.add('/m/32423423');
                  // Navigator.of(context).pushNamed('/m');
                  FlavorRouterDelegate.of(context).push(Uri(path: '/m/$index'));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class DLXShareButton extends StatelessWidget {
  const DLXShareButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      // size: buttonSize,
      circleColor: CircleColor(
          start: Colors.yellowAccent.shade200, end: Colors.yellow.shade700),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.yellowAccent.shade200,
        dotSecondaryColor: Colors.yellowAccent.shade700,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          !isLiked ? Icons.share_outlined : Icons.share_rounded,
          color: Colors.grey,
          // size: buttonSize,
        );
      },
      // likeCount: 54,
    );
  }
}

class DLXAddButton extends StatelessWidget {
  const DLXAddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      // size: buttonSize,
      circleColor: CircleColor(start: Colors.white12, end: Colors.white),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.white12,
        dotSecondaryColor: Colors.white,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          !isLiked ? Icons.add_box_outlined : Icons.add_box_rounded,
          color: isLiked ? Colors.white60 : Colors.grey,
          // size: buttonSize,
        );
      },
    );
  }
}

class DLXLikeButton extends StatelessWidget {
  const DLXLikeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      // size: buttonSize,
      circleColor: CircleColor(start: Colors.red, end: Colors.red),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.pinkAccent,
        dotSecondaryColor: Colors.pinkAccent.shade700,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          !isLiked ? Icons.favorite_border_outlined : Icons.favorite_rounded,
          color: isLiked ? Colors.red : Colors.grey,
          // size: buttonSize,
        );
      },
      likeCount: 54,
      countBuilder: (int? count, bool isLiked, String text) {
        var color = isLiked ? Colors.red : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "love",
            style: TextStyle(color: color),
          );
        } else
          result = Text(
            text,
            style: TextStyle(color: color),
          );
        return result;
      },
    );
  }
}

List<Section> _homeSections = [
  // Story
  Section(
    title: 'Story',
    items: [
      SectionItem(),
    ],
  ),
  // Story
  Section(
    title: 'Music',
    items: [
      SectionItem(),
    ],
  ),
  // Story
  Section(
    title: 'Featured',
    items: [
      SectionItem(),
    ],
  ),

  Section(
    title: 'Feed',
    items: [
      SectionItem(),
    ],
  ),
  // Story
];

List<Section> _inboxSections = [
  // Story
  Section(
    title: 'Story',
    items: [
      SectionItem(),
    ],
  ),
  // Story
  Section(
    title: 'Messages',
    items: [
      SectionItem(),
    ],
  ),
];
