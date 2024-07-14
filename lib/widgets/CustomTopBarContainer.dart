
import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/styles.dart';

class CustomTopBarContainer extends StatelessWidget {
  const CustomTopBarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgClr2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text('1', style: Styles.navSelTextStyle(fontSize: 10,height: 11.72/10,fontWeight: FontWeight.w600,color: Colors.white,letterSpacing: 0)),
              ],
            ),
          ),
          // Progress Bar
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 8,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: barUnfilledClr.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: constraints.maxWidth * 0.6, // Adjust this value for the progress
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Second Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: buttonBgClr,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image.asset('assets/Ticket.png', width: 14, height: 14),
                SizedBox(width: 4),
                Text('1/7', style: Styles.navSelTextStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
