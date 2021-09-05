import 'package:dlxstudios_app/components/pageviewer.dart';
import 'package:dlxstudios_app/dash/state.dart';
import 'package:flavor_client/layout/FlavorResponsiveView.dart';
import 'package:flavor_client/layout/adaptive.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppLayoutWidget extends StatefulWidget {
  final String? viewId;
  const AppLayoutWidget({
    Key? key,
    this.viewId,
  }) : super(key: key);

  @override
  _AppLayoutWidgetState createState() => _AppLayoutWidgetState();
}

class _AppLayoutWidgetState extends State<AppLayoutWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  @override
  void initState() {
    super.initState();

    if (widget.viewId != null) {
      _tabController = new TabController(
        length: routesForDrawer.length,
        vsync: this,
        initialIndex: _selectedIndex,
      );
    } else {
      _tabController = new TabController(
        length: routesForDrawer.length,
        vsync: this,
        initialIndex: _selectedIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorResponsiveView(
      breakpoints: {
        DisplayType.s: buildMobileView(context),
        DisplayType.l: Scaffold(
          // key: homeScaffoldKey,
          body: Row(
            children: [
              Container(
                width: 160,
                child: NavigationRail(
                  elevation: 1,
                  onDestinationSelected: (value) {
                    _tabController.animateTo(value);
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                  extended: true,
                  leading: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  destinations: routesForDrawer
                      .map(
                        (e) => NavigationRailDestination(
                          padding: EdgeInsets.all(4),
                          label: Text(e.title.toString()),
                          icon: Icon(e.icon),
                          // selectedIcon: Icon(
                          //   Icons.home_rounded,
                          //   // color: Colors.amber,
                          // ),
                        ),
                      )
                      .toList(),
                  selectedIndex: _selectedIndex,
                ),
              ),
              Flexible(
                flex: 11,
                child: Scaffold(
                    // appBar: homeAppBar(context),
                    // body: BiteSiteHomeBody(),
                    body: buildMobileView(context)),
              ),
            ],
          ),
        ),
        // DisplayType.xl: Scaffold(
        //   appBar: homeAppBar(context),
        //   body: BiteSiteHomeBody(),
        // ),
      },
    );
  }

  Widget buildMobileView(BuildContext context) {
    return FlavorResponsiveView(
      global: true,
      breakpoints: {
        DisplayType.s: Scaffold(
          // key: homeScaffoldKey,
          appBar: buildAppBar(context),
          drawer: buildDrawer(),
          body: buildBody(),
          bottomNavigationBar: buildBottomBar(),
        ),
        DisplayType.l: Scaffold(
          // key: homeScaffoldKey,
          // appBar: buildAppBar(context),
          drawer: buildDrawer(),
          body: buildBody(),
        ),
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var app = context.read<DashAppState>();
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        height: 58,
        padding: EdgeInsets.all(12),
        // color: Colors.amber,
        child: Row(
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        // height: 18,
      ),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.all(12.0),
      //     child: app.user == null
      //         ? TextButton(
      //             onPressed: () =>
      //                 GlobalNav.currentState!.pushNamed('/account'),
      //             child: Text('login'))
      //         : CircleAvatar(
      //             child: GestureDetector(
      //               child: Icon(Icons.person),
      //               onTap: () => GlobalNav.currentState!.pushNamed('/account'),
      //             ),
      //           ),
      //   ),
      //   SizedBox(
      //     width: 16,
      //   ),
      // ],
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
                icon: Icon(e.icon),
              ),
            )
            .toList(),
      ),
    );
  }

  TabBarView buildBody() {
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
}
