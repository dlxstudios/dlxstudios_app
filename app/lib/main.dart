import 'package:dlxstudios_app/app.dart';
import 'package:dlxstudios_app/state/state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavor_client/client/flavor_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart' as Provider;

// Future<void> main() async {
//   // await runClient(DLXAppV1());

//   await runClient(DLXApp());
// }

Future<void> main() async {
  await Hive.initFlutter();

  await Firebase.initializeApp();
  // runClient(
  //   ChangeNotifierProvider<DashAppState>(
  //     create: (context) => DashAppState(appBox),
  //     child: DLXApp(),
  //   ),
  // );
  var appBox = await Hive.openBox('dlxstudios_app');

  await runClient(ProviderScope(
    child: Provider.ChangeNotifierProvider<DashAppState>(
      create: (context) => DashAppState(appBox),
      child: Provider.Consumer<DashAppState>(
        builder: (context, value, child) => DLXApp(app: value),
      ),
    ),
  ));
}
