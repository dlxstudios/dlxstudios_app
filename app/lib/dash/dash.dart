import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:dlxstudios_app/components/pageviewer.dart';
import 'package:dlxstudios_app/dash/layout.dart';
import 'package:dlxstudios_app/dash/state.dart';
import 'package:flavor_client/client/flavor_state.dart';
import 'package:flavor_client/components/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DashV1 extends StatelessWidget {
  const DashV1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var app = context.watch<DashAppState>();
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: AudioServiceWidget(
        child: DashAppLayoutWidget(),
      ),
    );
  }
}

class SharedAxisTransitionPageWrapper extends Page {
  const SharedAxisTransitionPageWrapper({
    required this.screen,
    required this.transitionKey,
  })  : assert(screen != null),
        assert(transitionKey != null),
        super(key: transitionKey);

  final Widget screen;
  final ValueKey transitionKey;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        fullscreenDialog: true,
        transitionDuration: Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return screen;
        });
  }
}

class DashAppIndex extends StatefulWidget {
  const DashAppIndex({Key? key}) : super(key: key);

  @override
  _DashAppIndexState createState() => _DashAppIndexState();
}

class _DashAppIndexState extends State<DashAppIndex> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 40),
            child: DashAppBar(
              leading: Row(
                children: [
                  DashMenuButton(
                    icon: Icons.music_off_rounded,
                  ),
                ],
              ),
            ),
          ),
          body: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildDrawer(),
              Expanded(
                // flex: 7,
                child: Container(
                    // color: Colors.amber,
                    child: buildPageView()
                    // : Navigator(
                    //     key: navigatorKey,
                    //     onPopPage: (route, result) =>
                    //         _handlePopPage(route, result),
                    //     pages: [
                    //       SharedAxisTransitionPageWrapper(
                    //         screen: Container(),
                    //         transitionKey: ValueKey('page.n'),
                    //       )
                    //     ],
                    //   ),
                    // child: Navigator(
                    //   key: navigatorKey,
                    //   onPopPage: (route, result) =>
                    //       _handlePopPage(route, result),
                    //   pages: pages,
                    // ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // app.removeListener(notifyListeners);
    super.dispose();
  }

  int menuSelectedIndex = 0;

  final PageController _pc = PageController(
    keepPage: true,
    initialPage: 0,
  );

  Duration _pageChangeDuration = Duration(milliseconds: 280);

  PageView buildPageView() {
    return PageView(
      restorationId: 'hmm,idk',
      pageSnapping: true,
      scrollDirection: Axis.vertical,
      controller: _pc,
      physics: NeverScrollableScrollPhysics(),
      children:
          routesForDrawer.map((e) => PageViewItem(child: e.child)).toList(),
    );
  }

  Widget buildDrawer() {
    return Container(
      width: 160,
      // color: Colors.grey.shade800,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 16),
        itemExtent: 48,
        itemCount: routesForDrawer.length,
        itemBuilder: (context, index) => Center(
          child: DashMenuButton(
            text: routesForDrawer[index].title.toString(),
            color: routesForDrawer[index].backgroundColor,
            icon: routesForDrawer[index].icon,
            onTap: () => _pc.animateToPage(index,
                duration: _pageChangeDuration, curve: Curves.easeInOutExpo),
          ),
        ),
      ),
    );
  }

  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    final bool didPop = route.didPop(result);
    print('_handlePopPage::didPop - $didPop');
    // if (_pages.length > 1) _pages.removeAt(_pages.length - 1);
    // print('_pages.length::${_pages.length}');
    // print('_handlePopPage::didPop::numPages - ${_pages[0].path}');
    // removeLastUri();
    return didPop;
  }

  // @override
  // void removeListener(VoidCallback listener) {
  //   // TODOs: implement removeListener
  // }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<Uri> _pages = [Uri(path: '/')];

  /// Getter for a list that cannot be changed
  List<Page> get pages => List.unmodifiable(_pages).map((e) {
        // FlavorRouteWidget? _page = routesMap[e.path];
        FlavorRouteWidget? _page;

        // for (var i = 0; i < dashRoutes.length; i++) {
        //   print(
        //       'each::routes[i].path - ${dashRoutes[i].path} && ${currentConfiguration.path}');
        //   if (dashRoutes[i].path == currentConfiguration.path) {
        //     _page = dashRoutes[i];
        //   }
        // }

        // print(
        //     'app.routesMap.length.toString()::${app.routesMap.length.toString()}');
        if (_page == null)
          return SharedAxisTransitionPageWrapper(
              screen: Column(
                children: [
                  Text(404.toString()),
                  Text('Page "${e.path}" doesnt exist'),
                ],
              ),
              transitionKey: ValueKey<String>(_page.hashCode.toString()));
        Widget _screen = _page;
        // print('_pages.length::${_pages.length}');
        if (_pages.length > 1) {
          _screen = Scaffold(
            body: _page,
            appBar: AppBar(),
          );
        }
        return SharedAxisTransitionPageWrapper(
            screen: _screen,
            transitionKey: ValueKey<String>(_page.hashCode.toString()));
      }).toList();
}

class DashAppBar extends StatelessWidget {
  final Widget? leading;

  final Widget? middle;

  final Widget? trailing;

  const DashAppBar({
    Key? key,
    this.leading,
    this.middle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 4,
        bottom: 0,
      ),
      // color: Colors.green,
      child: Row(
        children: [
          leading != null
              ? Flexible(
                  child: Container(
                    // padding: EdgeInsets.all(4),
                    color: Colors.amber,
                    child: leading,
                  ),
                )
              : Spacer(),
          Spacer(),
          middle != null
              ? Flexible(
                  child: Container(
                    // padding: EdgeInsets.all(4),
                    color: Colors.grey,
                    child: middle,
                  ),
                )
              : Spacer(),
          Spacer(),
          trailing != null
              ? Flexible(
                  child: Container(
                    // padding: EdgeInsets.all(4),
                    color: Colors.indigo,
                    child: trailing,
                  ),
                )
              : Spacer(),
        ],
      ),
    );
  }
}

class DashMenuButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Color? color;
  final void Function()? onTap;

  const DashMenuButton({
    Key? key,
    this.icon,
    this.text,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Icon(icon) : Container(),
            icon != null && text != null
                ? SizedBox(
                    width: 16,
                  )
                : Container(),
            text != null ? Text('$text') : Container(),
          ],
        ),
      ),
    );
  }
}

final dashAppStateGlobal = flavorState(dashAppState);

final FlavorClientState dashAppState = FlavorClientState(
  routes: dashRoutes,
);
