import 'package:dlxstudios_app/components/pageview_item.dart';
import 'package:dlxstudios_app/components/side_menu.dart';
import 'package:dlxstudios_app/providers/providers.dart';
import 'package:dlxstudios_app/state/state.dart';
import 'package:flavor_client/layout/FlavorResponsiveView.dart';
import 'package:flavor_client/layout/adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

class DashAppLayoutWidget extends StatefulWidget {
  final String? viewId;
  const DashAppLayoutWidget({
    Key? key,
    this.viewId,
  }) : super(key: key);

  @override
  _AppLayoutWidgetState createState() => _AppLayoutWidgetState();
}

class _AppLayoutWidgetState extends State<DashAppLayoutWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      length: routesForDrawer.length,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FlavorResponsiveView(
        global: true,
        breakpoints: {
          DisplayType.s: buildSmallView(),
          DisplayType.l: buildLargeView(),
        },
      ),
    );
  }

  Widget buildSmallView() {
    return Scaffold(
      key: GlobalScaffoldKey,
      // appBar: buildMobileAppBar(context),
      drawer: Container(
        width: 280,
        child: Material(
          child: SideMenu(
            onTap: (i) {
              _tabController.animateTo(i);
              setState(() {
                _selectedIndex = i;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          bottom: 68,
          child: Container(
            child: buildTabViewBody(),
          ),
        ),
        Positioned.fill(
          child: Consumer(builder: (context, watch, _) {
            final miniPlayerController =
                watch(miniPlayerControllerProvider).state;
            return Miniplayer(
              controller: miniPlayerController,
              minHeight: 80,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                return buildPlayer(height: height, percentage: percentage);
              },
            );
          }),
        )
      ],
    );
  }

  Widget buildLargeView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          bottom: 80,
          child: Scaffold(
            // backgroundColor: Colors.deepPurple,
            body: Row(
              children: [
                Container(
                  width: 200,
                  child: SideMenu(
                    selectedIndex: _selectedIndex,
                    onTap: (i) {
                      print('i::$i');
                      _tabController.animateTo(i);
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                  ),
                ),
                Expanded(child: buildTabViewBody())
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Consumer(builder: (context, watch, _) {
            final miniPlayerController =
                watch(miniPlayerControllerProvider).state;
            return Miniplayer(
              controller: miniPlayerController,
              minHeight: 100,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                return buildPlayer(height: height, percentage: percentage);
              },
            );
          }),
        )
      ],
    );
  }

  Widget buildMiniPlayerMin(double percentage) {
    // print(percentage);
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(2),
            // color: Colors.indigo,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Material(
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Container(
              // color: Colors.deepPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // margin: EdgeInsets.all(2),
                    // color: Colors.red,
                    child: Text(
                      'data data datadatadata',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.all(2),
                    // color: Colors.redAccent,
                    child: Text(
                      'data data datadatadata',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption!,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            // color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // color: Colors.deepOrange,
                  child: IconButton(
                    iconSize: 32,
                    padding: EdgeInsets.all(0),
                    splashRadius: 24,
                    onPressed: () {},
                    icon: Icon(Icons.play_arrow_outlined),
                  ),
                ),
                // SizedBox(
                //   width: 8,
                // ),
                Container(
                  // color: Colors.deepOrange,
                  child: IconButton(
                      iconSize: 32,
                      padding: EdgeInsets.all(0),
                      splashRadius: 24,
                      onPressed: () {},
                      icon: Icon(Icons.skip_next)),
                ),
              ]..add(
                  SizedBox(
                    width: 10,
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMiniPlayerMax(double percentage) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          primary: true,
          floating: true,
          elevation: 10,
          expandedHeight: MediaQuery.of(context).size.height / 1.8,
          collapsedHeight: (MediaQuery.of(context).size.height / 1.8) / 2,
          flexibleSpace: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Material(
                // color: Colors.green,
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Material(
                    elevation: 1,
                    child: Center(child: Text('Video Goes Here')),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Material(
                color: Colors.amberAccent,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Material(
                color: Colors.indigoAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Material buildBottomBar() {
    return Material(
      elevation: 4,
      child: TabBar(
        controller: _tabController,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        tabs: routesForDrawer
            .map(
              (e) => Tab(
                icon: Icon(
                  e.icon,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  TabBarView buildTabViewBody() {
    return TabBarView(
      controller: _tabController,
      children:
          routesForDrawer.map((e) => PageViewItem(child: e.child)).toList(),
    );
  }

  SizedBox buildDrawer() {
    return SizedBox(
      width: 260,
      child: Material(
        child: ListView(
          children: [
            ListTile(
              title: Text('Search'),
            ),
            ListTile(
              title: Text('Orders'),
            ),
            ListTile(
              title: Text('Payment'),
            ),
            ListTile(
              title: Text('Sign Out'),
            ),
            ListTile(
              title: Text('Help'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayer({required double height, required double percentage}) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: AnimatedContainer(
        padding: EdgeInsets.only(
          left: percentage > 0.01 ? 0 : 8,
          right: percentage > 0.01 ? 0 : 8,
          bottom: percentage > 0.01 ? 0 : 8,
        ),
        duration: Duration(milliseconds: 200),
        child: Material(
          elevation: 5,
          child: height <= 60 + 50.0
              ? buildMiniPlayerMin(percentage)
              : buildMiniPlayerMax(percentage),
        ),
      ),
    );
  }
}
