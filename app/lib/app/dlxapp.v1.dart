import 'package:audio_service/audio_service.dart';
import 'package:dlxstudios_app/app/state.dart';
import 'package:flavor_client/layout/app.dart';
import 'package:flutter/material.dart';

class DLXApp extends StatefulWidget {
  @override
  _DLXAppV1State createState() => _DLXAppV1State();
}

class _DLXAppV1State extends State<DLXApp> {
  @override
  void initState() {
    print('_DLXAppV1State::init');
    // final gsignin = GoogleSignIn.standard(scopes: ['email']);

    // signInWithGoogle().then((creds) {
    //   print('_DLXAppV1State::signInWithGoogle::creds::${creds == null}');
    //   if (creds != null) {
    //     appState.user = FlavorUser(
    //       displayName: creds.user!.displayName,
    //       email: creds.user!.email,
    //       photoUrl: creds.user!.photoURL,
    //     );

    //     FirebaseAuth.instance.signInWithCredential(
    //         AuthCredential(providerId: 'google', signInMethod: ''));
    //   } else {
    //     FirebaseAuth.instance.signInAnonymously().then((value) {
    //       User user = value.user!;
    //       appState.user = FlavorUser(
    //         displayName: value.user!.displayName,
    //         email: value.user!.email,
    //         photoUrl: value.user!.photoURL,
    //         emailVerified: user.emailVerified,
    //         providerId: user.providerData.toString(),
    //       );
    //     });
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Starting:: DLX app');

    return AudioServiceWidget(child: FlavorApp(dlxAppStateGlobal));
  }
}

class DLXAppV1 extends StatelessWidget {
  const DLXAppV1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(child: FlavorApp(dlxAppStateGlobal));
  }
}
