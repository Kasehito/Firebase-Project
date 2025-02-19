import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';
import 'package:manganjawa/bindings/navigation_binding.dart';
import 'package:manganjawa/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:manganjawa/theme/dark_mode.dart';
import 'theme/light_mode.dart';
import 'package:manganjawa/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      persistenceEnabled: !kIsWeb);
  final authService = Get.put(AuthService());
  await authService.           initializeAuthStatus();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.login,
      initialBinding: NavigationBinding(),
      getPages: MyRoutes.pageRoutes,
      defaultTransition: Transition.fadeIn,
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
