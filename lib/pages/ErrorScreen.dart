import 'package:flutter/material.dart';

class InternalServerErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error")),
      body: Center(
        child: Text("500 Internal Server Error", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class NotFoundErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error")),
      body: Center(
        child: Text("404 Not Found", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
