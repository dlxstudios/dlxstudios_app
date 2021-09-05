import 'package:dlxstudios_app/app/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_client/client/flavor_state.dart';
import 'package:flavor_client/components/Page.dart';
import 'package:flavor_auth/flavor_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

String? passwordValidator(String? txt) {
  return txt != null && txt.length > 6
      ? null
      : 'Password should be over 6 characters long. Just lay your hand on the keybord for 1 second.';
}

String? repasswordValidator(String? txt) {
  return txt != null && txt.length > 6
      ? null
      : 'Password should be over 6 characters long. Just lay your hand on the keybord for 1 second.';
}

String? emailValidator(String? txt) {
  return txt != null && txt.length > 6
      ? null
      : 'Password should be over 6 characters long. Just lay your hand on the keybord for 1 second.';
}

class DLXPageOnboarding extends StatefulWidget {
  @override
  _DLXPageOnboardingState createState() => _DLXPageOnboardingState();
}

class _DLXPageOnboardingState extends State<DLXPageOnboarding> {
  final _onBoardFormLoginKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _onBoardFormSignUpKey = GlobalKey<FormState>();
  final _passwordTextController = TextEditingController(
    text: 'alita01',
  );
  final _repasswordTextController = TextEditingController(
    text: 'alita01',
  );
  final _usernameTextController = TextEditingController(
    text: 'alita@dlxstudios.com',
  );

  var loginError;
  bool notBusy = true;
  var signinError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    _repasswordTextController.dispose();
    super.dispose();
  }

  Widget buildFormSignUp() {
    return DLXPageOnboardingSignUp(
        onBoardFormSignUpKey: _onBoardFormSignUpKey,
        signinError: signinError,
        notBusy: notBusy,
        usernameTextController: _usernameTextController,
        passwordTextController: _passwordTextController,
        repasswordTextController: _repasswordTextController);
  }

  Widget buildFormLogin() {
    return DLXPageOnboardingLogin(
      formLoginKey: _onBoardFormLoginKey,
      loginError: loginError,
      notBusy: notBusy,
      usernameTextController: _usernameTextController,
      passwordTextController: _passwordTextController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, watch, Widget? child) {
        FlavorClientState app = watch(dlxAppStateGlobal);

        Future loginWithEmail() {
          return FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: _usernameTextController.value.text,
            password: _passwordTextController.value.text,
          )
              .then((value) {
            print(value.user!.email);
            User user = value.user!;
            app.user = FlavorUser(
              displayName: user.displayName,
              email: user.email,
              photoUrl: user.photoURL,
              localId: user.uid,
            );
          }).catchError(
            (err) {
              if (err
                  .toString()
                  .contains('The email address is badly formatted')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    // behavior: SnackBarBehavior.floating,
                    // width: 300,
                    content: Text(
                        'Please double check your email address. Like fr tho, it really dont look like an email at all ')));
              } else if (err.toString().contains('wrong-password')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    // behavior: SnackBarBehavior.floating,
                    // width: 300,
                    content: Text(
                        'Failed! Either the email or password is incorrect. Please try again.')));
              } else if (err.toString().contains('too-many-request')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    // behavior: SnackBarBehavior.floating,
                    // width: 300,
                    content: Text(
                        'You tried too many times. Please allow up to 60 seconds or select "Forgot Password" ')));
              }
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          primary: true,
          appBar: AppBar(),
          key: _scaffoldKey,
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FlavorPageView(
              children: [
                Container(
                  height: 160,
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.2021.svg',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : null,
                    ),
                  ),
                ),

                // buildFormLogin(),

                DLXPageOnboardingLogin(
                  formLoginKey: _onBoardFormLoginKey,
                  loginError: loginError,
                  notBusy: notBusy,
                  usernameTextController: _usernameTextController,
                  passwordTextController: _passwordTextController,
                  onLogin: loginWithEmail,
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Buttons

                      // ElevatedButton.icon(
                      //   icon: Icon(Icons.email),
                      //   onPressed: () {},
                      //   label: Text('Login '),
                      // ),

                      TextButton.icon(
                        icon: Icon(Icons.email_outlined),
                        onPressed: () {
                          // _scaffoldKey.currentState!.showBottomSheet(
                          //   (context) => Scaffold(
                          //     appBar: AppBar(
                          //       backgroundColor: Colors.transparent,
                          //       elevation: 0,
                          //       title: Text('Sign up'),
                          //     ),
                          //     body: Container(
                          //       // height: 200,
                          //       // color: Colors.amber,
                          //       child: buildFormSignUp(),
                          //     ),
                          //   ),
                          // );

                          // Router.of(context)
                          //     .routerDelegate
                          //     .setNewRoutePath(Uri(path: '/account/signup'));
                        },
                        label: Text('Create Account'),
                      ),

                      // // Google
                      // ElevatedButton(
                      //   onPressed: () {
                      //     signInWithGoogle()
                      //         .then((value) => app.user = FlavorUser());
                      //   },
                      //   child: Text('Google'),
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all(
                      //       Colors.orange.shade900,
                      //     ),
                      //   ),
                      // ),
                      // // Apple
                      // ElevatedButton(
                      //   onPressed: () {
                      //     signInWithGoogle()
                      //         .then((value) => app.user = FlavorUser());
                      //   },
                      //   child: Text('Apple'),
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all(
                      //       Colors.grey.shade700,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: Container(
          //   padding: EdgeInsets.all(12),
          //   height: (12 * 2) * 3,
          //   // color: Colors.amber,
          //   child: Text('Terms of service'),
          // ),

          bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Terms of service'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Support'),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}

class DLXPageOnboardingLogin extends StatelessWidget {
  const DLXPageOnboardingLogin({
    Key? key,
    this.loginError,
    this.notBusy = true,
    this.usernameTextController,
    this.passwordTextController,
    this.formLoginKey,
    this.onLogin,
  }) : super(key: key);

  final GlobalKey<FormState>? formLoginKey;
  final String? loginError;
  final bool notBusy;
  final TextEditingController? usernameTextController;
  final TextEditingController? passwordTextController;
  final void Function()? onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formLoginKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // SizedBox(
            //   height: 20,
            // ),
            // Center(
            //   child: Text(
            //     'Login',
            //     style: TextStyle(
            //       fontSize: 26,
            //       fontWeight: FontWeight.w300,
            //     ),
            //   ),
            // ),

            loginError != null
                ? Center(
                    child: Text(
                      '$loginError',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                : Container(
                    height: 20,
                  ),

            // SizedBox(
            //   height: 10,
            // ),

            /// Fields
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Username BOX

                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DLXTextField(
                      notBusy: notBusy,
                      textController: usernameTextController,
                      validator: emailValidator,
                      labelText: 'Email',
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  // Password BOX
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DLXTextField(
                      notBusy: notBusy,
                      textController: passwordTextController,
                      validator: passwordValidator,
                      labelText: 'Password',
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              // color: Colors.purple,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Forgot Password

                  TextButton(
                    // color: Colors.red,
                    onPressed: !notBusy
                        ? null
                        : () {
                            print('forgot password');
                          },
                    child: Text('forgot password'),
                  ),

                  // Login Button
                  ElevatedButton(
                    // onPressed: notBusy && onLogin != null
                    //     ? onLogin
                    //     : () {
                    //         print('onLogin.pressed::true');
                    //         // if (formLoginKey!.currentState!.validate()) {
                    //         //   // FlavorAuthEmail(
                    //         //   //         googleApiKey:
                    //         //   //             Firebase.app().options.apiKey)
                    //         //   //     .signInWithPassword(
                    //         //   //   _usernameTextController.value.text,
                    //         //   //   _passwordTextController.value.text,
                    //         //   // );

                    //         // }
                    //       },
                    onPressed: () {
                      if (notBusy &&
                          onLogin != null &&
                          formLoginKey!.currentState!.validate()) {
                        onLogin!();
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // // SignUp Button
            // TextButton(
            //   onPressed: !notBusy ? null : () {},
            //   child: Row(
            //     children: <Widget>[
            //       Text('New user? '),
            //       Text(
            //         'Signup',
            //         style: TextStyle(color: Colors.amber),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class DLXPageOnboardingSignUp extends StatelessWidget {
  DLXPageOnboardingSignUp({
    Key? key,
    this.onBoardFormSignUpKey,
    this.signinError,
    this.notBusy = true,
    this.usernameTextController,
    this.passwordTextController,
    this.repasswordTextController,
  }) : super(key: key);

  late GlobalKey<FormState>? onBoardFormSignUpKey;
  final String? signinError;
  final bool? notBusy;
  late TextEditingController? usernameTextController;
  late TextEditingController? passwordTextController;
  late TextEditingController? repasswordTextController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: onBoardFormSignUpKey,
        child: ListView(
          children: <Widget>[
            signinError != null
                ? Center(
                    child: Text(
                      '$signinError',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                : Container(
                    height: 20,
                  ),

            // SizedBox(
            //   height: 10,
            // ),

            /// Fields
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Username BOX

                  DLXTextField(
                    notBusy: notBusy!,
                    textController: usernameTextController,
                    validator: emailValidator,
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  // Password BOX
                  DLXTextField(
                    notBusy: notBusy!,
                    textController: passwordTextController,
                    validator: passwordValidator,
                    obscureText: true,
                  ),

                  // Password TWOOO
                  SizedBox(
                    height: 16,
                  ),

                  DLXTextField(
                    notBusy: notBusy!,
                    textController: repasswordTextController,
                    validator: repasswordValidator,
                    obscureText: true,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // Login Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: !notBusy!
                      ? null
                      : () {
                          Router.of(context).routerDelegate.popRoute();
                        },
                  child: Row(
                    children: <Widget>[
                      Text('Already a user?  '),
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.amber),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: !notBusy!
                      ? null
                      : () {
                          if (onBoardFormSignUpKey!.currentState!.validate()) {}
                        },
                  child: Text('Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DLXTextField extends StatelessWidget {
  DLXTextField({
    Key? key,
    this.notBusy = true,
    this.textController,
    this.validator,
    this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  final bool notBusy;
  late TextEditingController? textController;
  final String? Function(String?)? validator;
  final String? labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    if (textController == null) {
      textController = TextEditingController();
    }

    return TextFormField(
      enabled: notBusy,
      controller: textController,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(),
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        // border: InputBorder.none,
      ),
    );
  }
}
