import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:superfan/utils/color.dart';
import 'package:superfan/utils/routes.dart';
import 'package:superfan/widgets/GoogleSignInButton.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../services/Api.dart';

class LoginScreen extends StatelessWidget {
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/auth/google'));
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (await canLaunch(redirectUrl!)) {
          // Open the redirect URL in the browser
          await launch(redirectUrl);
          // Handle the callback from Google (you need to set up a way to listen to the callback in your app)
          await _handleGoogleCallback(context);
        } else {
          throw Exception('Could not launch $redirectUrl');
        }
      } else {
        throw Exception('Failed to initiate Google sign-in');
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<void> _handleGoogleCallback(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/auth/google/callback?code=authCode'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];
        final token = responseData['token'];

        // Save tokens and proceed with the app logic
        // For example, navigate to the home screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
              (Route<dynamic> route) => false,
          arguments: token,
        );
      } else {
        throw Exception('Failed to handle Google callback');
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: lightbgClr,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Ellipse 157.png', width: 272.0, height: 272.0),
            Text(
              'Sign in to your Account',
              style: TextStyle(
                fontSize: 24.0,
                height: 28.8 / 24,
                fontWeight: FontWeight.w700,
                color: whiteClr,
              ),
            ),
            SizedBox(height: 39.0),
            GoogleSignInButton(onPressed: () => _handleGoogleSignIn(context)),
          ],
        ),
      ),
    );
  }
}
