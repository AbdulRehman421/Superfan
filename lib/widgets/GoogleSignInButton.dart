import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superfan/utils/color.dart';
import '../services/Api.dart';
import '../utils/routes.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;

  GoogleSignInButton({super.key, required this.onPressed});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  void initState() {
    super.initState();
    signOut(context);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 47.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: ElevatedButton.icon(
          onPressed: () async {
            await signInWithGoogle(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset(
              'assets/googleIcon.png',
              height: 18.0,
              width: 18.0,
            ),
          ),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF1A1C1E),
            backgroundColor: bgContainerClr,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: bgContainerClr,
                width: 1.0,
              ),
            ),
            elevation: 0,
            shadowColor: const Color(0x99F4F5FA),
            minimumSize: const Size(280.0, 50.0),
          ).copyWith(
            shadowColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.15),
            ),
            elevation: MaterialStateProperty.all(0),
            side: MaterialStateProperty.all(
              const BorderSide(color: Color(0xFFEFF0F6)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        final response = await verifyTokenWithBackend(idToken!, user);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final newToken = responseData['token'];
          final refreshToken = responseData['refreshToken'];
          await saveTokenToPreferences(newToken, refreshToken);
          Navigator.pushNamed(context, Routes.home);
        } else {
          showError(context, 'Token verification failed');
        }
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  Future<http.Response> verifyTokenWithBackend(String idToken, User user) async {
    print('Token: $idToken');
    print('First name: ${user.displayName?.split(' ').first}');
    print('Last name: ${user.displayName?.split(' ').last}');
    print('Email: ${user.email}');
    print('Image URL: ${user.photoURL}');

    final response = await ApiClient().post(
      '${AppConstants.baseUrl}/auth/verify_token',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(<String, String>{
        'idToken': idToken,
        'email': user.email ?? '',
        'first_name': user.displayName?.split(' ').first ?? '',
        'last_name': user.displayName?.split(' ').last ?? '',
        'photoURL': user.photoURL ?? '',
      }),
    );

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } else {
      print('Failed to verify token. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return response;
  }

  Future<void> saveTokenToPreferences(String token, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
    await prefs.setString('refreshToken', refreshToken);
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
