import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superfan/utils/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is logged in
  final bool isLoggedIn = await checkLoginStatus();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? jwtToken = prefs.getString('jwtToken');
  return jwtToken != null;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn ? Routes.home : Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
