import 'package:dlxstudios_app/state/state.dart';
import 'package:dlxstudios_app/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_auth/flavor_auth.dart';
import 'package:flavor_client/pages/onboarding/onboarding_v3.dart';
import 'package:flavor_client/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as Provider;

class ScreenAccount extends StatefulWidget {
  @override
  _ScreenAccountState createState() => _ScreenAccountState();
}

class _ScreenAccountState extends State<ScreenAccount> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var app = context.watch<DashAppState>();

      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
            body: Stack(
          fit: StackFit.expand,
          children: [
            app.user != null ? buildProfile(app) : ScreenLogin(),
          ],
        )),
      );
    });
  }

  Widget buildProfile(DashAppState app) {
    var displayName = TextEditingController(
      text: app.user!.displayName ?? '',
    );

    var emailTextEditingController = TextEditingController(
      text: app.user!.email ?? '',
    );

    // var phone = TextEditingController(
    //   text: app.user!.displayName ?? '',
    // );

    String userDocPath = 'users/${app.user!.email}';

    List<AccountTextFeild> _textFields = [
      AccountTextFeild(
        labelText: 'Name',
        controller: displayName,
        onChanged: (dn) {
          FirebaseAuth.instance.currentUser!.updateDisplayName(dn);
        },
      ),
      AccountTextFeild(
        labelText: 'Email',
        controller: emailTextEditingController,
        onChanged: (dn) => FirebaseAuth.instance.currentUser!.updateEmail(dn),
      ),
      AccountTextFeild(
        labelText: 'Phone',
        controller: TextEditingController(),
        onChanged: (dn) => FlavorFirestoreRepository()
            .firestore
            .doc(userDocPath)
            .set({'phone': dn}),
      ),
    ];
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            // constraints: BoxConstraints(
            //   minWidth: 320,
            //   maxWidth: 600,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Personal info

                app.user != null
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return ProfileHeader(title: 'Personal Info');
                          }
                          return _textFields[index - 1];
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: _textFields.length + 1,
                      )
                    : Container(),

                SizedBox(
                  height: 16,
                ),

                ElevatedButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Logout'),
                  onPressed: () => app.logoutUser(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String title;

  const ProfileHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              '$title',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountTextFeild extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;

  final void Function(String)? onChanged;
  const AccountTextFeild({
    Key? key,
    this.labelText,
    this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorRadius: Radius.circular(16.0),
      cursorWidth: 1.0,
      keyboardType: TextInputType.emailAddress,
      // textInputAction: TextInputAction.continueAction,
      decoration: inputBorder(context, labelText),
      onChanged: onChanged,
    );
  }
}

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var app = context.watch<DashAppState>();
      return FlavorOnboardingV3(
        gApiKey: 'AIzaSyDaGm_f6SvznyHIQnPHk7s4V2UygStMb6g',
        isLoggedIn: app.user != null,
        onEmailLogin: (email, password) {
          try {
            return FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password)
                .then(
              (value) {
                print('app.user::${value.user!.displayName}');
                return app.user = FlavorUser(
                  displayName: value.user!.displayName,
                  email: value.user!.email,
                  emailVerified: value.user!.emailVerified,
                  localId: value.user!.uid,
                  photoUrl: value.user!.photoURL,
                );
              },
            );
          } catch (e) {
            return Future.error(e);
          }
        },
        // ).then((value) => GlobalNav.currentState!.pop()),
        // .then((value) => GlobalNav.currentState!.popAndPushNamed('/')),
        // onEmailLogin: (email, password) {
        //   print('$email, $password');
        //   return Future.value();
        // },
        onEmailSignup: (email, password, passwordReEnter) =>
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
                .then((value) {
          print(value);
          return app.user = FlavorUser(
            displayName: value.user!.displayName,
            email: value.user!.email,
            emailVerified: value.user!.emailVerified,
            localId: value.user!.uid,
            photoUrl: value.user!.photoURL,
          );
        })
        // .then((value) => GlobalNav.currentState!.popAndPushNamed('/'))
        ,
      );
    });
  }
}
