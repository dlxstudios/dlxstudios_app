import 'package:dlxstudios_app/app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_client/client/flavor_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

final dlxAppStateGlobal = flavorState(appState);

final FlavorClientState appState = FlavorClientState(
  routes: routes,
);

Future<UserCredential> signInWithGoogle() async {
  // GoogleSignIn().signInSilently();

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
