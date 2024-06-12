import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'UI/pages/login_page.dart';
import 'UI/widgets/navigation_bar.dart';
import 'UI/widgets/splash_screen.dart';
import 'controllers/auth_controller.dart';

import 'UI/pages/batches/batch_page.dart';
import 'UI/pages/sign_up_page.dart';


//importaciones firebase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBOkRQvsxoUvvG_k-3kxY8p55fjwegINTM",
            appId: "1:173997870344:web:fda390459bc809ff7530bd",
            messagingSenderId: "173997870344",
            projectId: "moo-app-6485e",
            storageBucket: "gs://moo-app-6485e.appspot.com"));
  }
  await Firebase.initializeApp().then((value) {
    Get.put(AuthenticationController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moo App',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      routes: {
        '/': (context) => const SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const NavBar(),
        '/batch': (context) => const BatchPage(),
      },
    );
  }
}
