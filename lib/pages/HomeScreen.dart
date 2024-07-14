import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/styles.dart';
import 'HomeWidget.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? _buildSelectedIcon(Icons.home)
                  : Icon(Icons.home_outlined, color: navUnSelTextClr, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? _buildSelectedIcon(Icons.person)
                  : Icon(Icons.person_outline, color: navUnSelTextClr, size: 24),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: navSelTextClr,
          unselectedItemColor: navUnSelTextClr,
          onTap: _onItemTapped,
          selectedLabelStyle: Styles.navSelTextStyle(),
          unselectedLabelStyle: Styles.navUnSelTextStyle,
        ),
      ),
    );
  }

  Widget _buildSelectedIcon(IconData iconData) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 64,
          height: 32,
          decoration: BoxDecoration(
            color: skyBlue,
            borderRadius: BorderRadius.circular(85),
          ),
        ),
        Icon(iconData, color: Colors.black, size: 24),
      ],
    );
  }
}
