import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:dlxstudios_app/components/pageview_item.dart';
import 'package:dlxstudios_app/components/layout.dart';
import 'package:dlxstudios_app/state/state.dart';
import 'package:dlxstudios_app/theme/theme.dart';
import 'package:flavor_client/client/flavor_state.dart';
import 'package:flavor_client/components/page.dart';
import 'package:flavor_client/components/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DLXApp extends StatelessWidget {
  final DashAppState app;
  const DLXApp({
    Key? key,
    required this.app,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: app.useDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: darkTheme(mcgpalette0, textTheme),
      theme: lightTheme(mcgpalette0, textTheme),
      debugShowCheckedModeBanner: false,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => PageError(
            errorCode: 404.toString(),
            msg: 'Unable to find "${settings.name}"',
          ),
        );
      },
      onGenerateRoute: app.router.generateRoute,
      home: AudioServiceWidget(
        child: DashAppLayoutWidget(app),
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
