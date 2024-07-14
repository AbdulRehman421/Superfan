import 'package:flutter/material.dart';
import 'package:superfan/utils/styles.dart';

import '../utils/color.dart';

class CustomQuizPicContainer extends StatelessWidget {
  const CustomQuizPicContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Container
        Container(
          width: 400, // Adjust as needed
          height: 400, // Adjust as needed
          decoration: BoxDecoration(
            color: lightbgClr,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              // Background Image
              Center(
                child: Image.asset(
                  'assets/Model.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Cross Icon
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
              // Timer Container
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  // width: 67,
                  // height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Adjust as needed
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xE38E031A).withOpacity(0.1),
                        blurRadius: 11,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: iconBgClr, size: 14), // Adjust size as needed
                      SizedBox(width: 2),
                      Text(
                        '00:05',
                        style: Styles.navSelTextStyle(color: iconBgClr),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
