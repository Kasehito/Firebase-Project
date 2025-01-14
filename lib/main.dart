import 'package:flutter/material.dart';
import 'package:manganjawa/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:manganjawa/theme/dark_mode.dart';
import 'theme/light_mode.dart';
import 'package:manganjawa/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.login,
      getPages: MyRoutes.pageRoutes,
      defaultTransition: Transition.fadeIn,
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
