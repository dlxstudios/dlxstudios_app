import 'package:dlxstudios_app/components/layout.dart';
import 'package:dlxstudios_app/providers/providers.dart';
import 'package:dlxstudios_app/screens/account.dart';
import 'package:dlxstudios_app/screens/admin.dart';
import 'package:dlxstudios_app/screens/home.dart';
import 'package:dlxstudios_app/screens/inbox.dart';
import 'package:dlxstudios_app/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_auth/flavor_auth.dart';
import 'package:flavor_client/repository/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flavor_client/components/route.dart';

import 'package:regex_router/regex_router.dart';

// ignore: non_constant_identifier_names
final GlobalKey<NavigatorState> GlobalNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> GlobalScaffoldKey = GlobalKey<ScaffoldState>();

class DashAppState extends ChangeNotifier {
  final Future<Box<dynamic>> appBox = Hive.openBox('dlxstudios.app');

  DashAppState() {
    if (appBox == null) {
      return;
    } else {
      loadAppSettings();
    }
  }

  bool _useDark = false;

  bool get useDark => _useDark;

  set useDark(bool value) {
    _useDark = !useDark;
    updateAndSave();
  }

  FlavorUser? _user;
  FlavorUser? get user => _user != null ? _user! : null;

  set user(FlavorUser? newUser) {
    _user = newUser;
    if (_user != null) {
      FlavorFirestoreRepository()
          .firestore
          .doc('users/${_user!.email}')
          .set(_user!.toJson() as Map<String, dynamic>);
    }
    updateAndSave();
    notifyListeners();
  }

  get router {
    Map<String, Widget Function(BuildContext, RouteArgs)> map = {};
    for (var i = 0; i < dashRoutes.length; i++) {
      map.putIfAbsent(
        dashRoutes[i].path,
        () => (context, args) => ScreenHome(args: args),
      );
    }

    return RegexRouter.create(map);
  }

  void updateAndSave() {
    appBox.then(
        (value) => value.put('_user', user != null ? user!.toJson() : null));
    appBox.then((value) => value.put('_useDark', _useDark));
    notifyListeners();
  }

  void loadAppSettings() {
    // appBox!.delete('_cart');

    //
    appBox.then((value) => value.get('_useDark') ?? _useDark);
    //
    var __user = appBox.then((value) => value.get('_user')).then((value) {
      return _user = value != null
          ? FlavorUser(
              displayName: value['displayName'],
              email: value['email'],
              emailVerified: value['emailVerified'],
              localId: value['localId'],
            )
          : null;
    });

    //
  }

  logoutUser() {
    FirebaseAuth.instance.signOut();
    user = null;
    notifyListeners();
    updateAndSave();
  }

  signInUser() {
    user = null;
    updateAndSave();
    notifyListeners();
  }

  List<FlavorRouteWidget> get dashRoutes => [
        FlavorRouteWidget(
          path: '/',
          icon: CupertinoIcons.home,
          title: 'Home',
          child: ScreenHome(),
          backgroundColor: Colors.green,
          routeInDrawer: true,
        ),
        FlavorRouteWidget(
          path: '/media/music',
          icon: CupertinoIcons.music_note,
          title: 'Music',
          child: ScreenHome(),
          backgroundColor: Colors.green,
          routeInDrawer: true,
        ),
        FlavorRouteWidget(
          path: '/p/messages',
          icon: CupertinoIcons.mail,
          title: 'Messages',
          child: ScreenInbox(),
          backgroundColor: Colors.green,
          routeInDrawer: true,
        ),
        FlavorRouteWidget(
          path: '/p/account',
          icon: CupertinoIcons.person,
          title: 'Account',
          child: ScreenAccount(),
          backgroundColor: Colors.green,
          routeInDrawer: true,
        ),
        FlavorRouteWidget(
          path: '/p/admin',
          icon: CupertinoIcons.multiply,
          title: 'Admin',
          child: ScreenAdmin(),
          backgroundColor: Colors.green,
          routeInDrawer: false,
        ),
        FlavorRouteWidget(
          path: '/p/settings',
          icon: CupertinoIcons.settings,
          title: 'Settings',
          child: ScreenSettings(),
          backgroundColor: Colors.green,
          routeInDrawer: true,
        ),
      ];

  List<FlavorRouteWidget> get routesForDrawer {
    List<FlavorRouteWidget> arr = [];
    for (var i = 0; i < dashRoutes.length; i++) {
      FlavorRouteWidget ii = dashRoutes[i];
      if (ii.routeInDrawer == true) {
        arr.add(ii);
      }
    }

    return arr;
  }
}
