import 'package:flutter/material.dart';
import 'package:superfan/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // You can use this to navigate to the next screen after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, Routes.login, (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash.gif'),
      ),
    );
  }
}
