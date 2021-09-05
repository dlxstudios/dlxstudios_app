import 'package:dlxstudios_app/pages/page_inbox.dart';
import 'package:dlxstudios_app/pages/page_index.dart';
import 'package:flavor_client/components/route.dart';
import 'package:flutter/material.dart';

List<FlavorRouteWidget> routes = [
  FlavorRouteWidget(
    path: '/',
    title: 'Home',
    child: DLXPageHome(),
    routeInDrawer: true,
    routeInTab: true,
    icon: Icons.home,
  ),
  FlavorRouteWidget(
    // backgroundColor: Colors.deepPurpleAccent,
    path: '/inbox',
    title: 'Inbox',
    child: DLXInboxPage(),
    icon: Icons.mail_outline,
    routeInDrawer: true,
    routeInTab: true,
  ),
];
