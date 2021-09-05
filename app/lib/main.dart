import 'package:dlxstudios_app/dash/dash.dart';
import 'package:dlxstudios_app/dash/state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavor_client/client/flavor_client.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Future<void> main() async {
//   // await runClient(DLXAppV1());

//   await runClient(DashV1());
// }

Future<void> main() async {
  await Hive.initFlutter();
  var appBox = await Hive.openBox('dlxstudios_app');
  await Firebase.initializeApp();
  runClient(
    ChangeNotifierProvider<DashAppState>(
      create: (context) => DashAppState(appBox),
      child: DashV1(),
    ),
  );

  // await runClient(DLXAppV1());
}
