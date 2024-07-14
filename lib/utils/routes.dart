import 'package:flutter/material.dart';
import 'package:superfan/pages/HomeWidget.dart';
import 'package:superfan/pages/LoginScreen.dart';
import 'package:superfan/pages/ProfileScreen.dart';
import 'package:superfan/pages/QuizResultScreen.dart';
import 'package:superfan/pages/QuizScreen.dart';
import 'package:superfan/pages/SplashScreen.dart';

import '../pages/HomeScreen.dart';
import '../pages/InfluencerDetailScreen.dart';

class Routes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String item1home = 'item1home';
  static const String profile = 'profile';
  static const String influencerDetail = 'influencerDetail';
  static const String quiz = 'quiz';
  static const String quizResult = 'quizResult';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case item1home:
        return MaterialPageRoute(builder: (_) => HomeWidget());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}


