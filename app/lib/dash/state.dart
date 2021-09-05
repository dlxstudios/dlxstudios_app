import 'package:dlxstudios_app/dash/dash_home.dart';
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
  final Box? appBox;

  DashAppState(this.appBox) {
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

  final router = RegexRouter.create({
    "/": (context, _) => DashHome(),
    // "/menu/category/:catId/item/:itemId/": (context, args) =>
    //     PageMenuItem(id: args["itemId"]!),
    // "/menu/category/:catId": (context, args) =>
    //     PageCategory(id: args["catId"]!),
  });

  void updateAndSave() {
    appBox!.put('_user', user != null ? user!.toJson() : null);
    appBox!.put('_useDark', _useDark);
    notifyListeners();
  }

  void loadAppSettings() {
    // appBox!.delete('_cart');

    //
    _useDark = appBox!.get('_useDark') ?? _useDark;
    //
    var __user = appBox!.get('_user');
    print(__user);
    _user = __user != null
        ? FlavorUser(
            displayName: __user['displayName'],
            email: __user['email'],
            emailVerified: __user['emailVerified'],
            localId: __user['localId'],
          )
        : null;

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
}

final List<FlavorRouteWidget> dashRoutes = [
  FlavorRouteWidget(
    path: '/',
    icon: CupertinoIcons.home,
    title: 'Home',
    child: DashHome(),
    backgroundColor: Colors.green,
    routeInDrawer: true,
  ),
  FlavorRouteWidget(
    path: '/music',
    icon: CupertinoIcons.home,
    title: 'Music',
    child: DashHome(),
    backgroundColor: Colors.green,
    routeInDrawer: true,
  ),
  FlavorRouteWidget(
    path: '/videos',
    icon: CupertinoIcons.home,
    title: 'Videos',
    child: DashHome(),
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
