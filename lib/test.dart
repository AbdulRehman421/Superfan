import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:superfan/utils/color.dart';
import 'package:superfan/widgets/rankColumn.dart';
import 'package:superfan/widgets/TopAppBarPainter.dart';
import 'package:superfan/widgets/rankCard.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Circle from top 132
        Positioned(
          top: 132,
          left: (MediaQuery.of(context).size.width - 600) / 2,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
          ),
        ),
        // Circle from top 222
        Positioned(
          top: 222,
          left: (MediaQuery.of(context).size.width - 420) / 2,
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RankColumn(
                  profileImagePath: 'assets/profile2.png',
                  flagImagePath: 'assets/flag2.png',
                  rankImagePath: 'assets/rank2.png',
                  title: 'Alena Donin',
                  points: '1,469 ',
                ),
                RankColumn(
                  profileImagePath: 'assets/Avatar.png',
                  flagImagePath: 'assets/flag1.png',
                  rankImagePath: 'assets/rank1.png',
                  title: 'Davis Curtis',
                  points: '2,569 ',
                  isFirst: true,
                ),
                RankColumn(
                  profileImagePath: 'assets/profile3.png',
                  flagImagePath: 'assets/flag3.png',
                  rankImagePath: 'assets/rank3.png',
                  title: 'Craig Gouse',
                  points: '1,053 ',
                  isThird: true,
                ),
              ],
            ),
            SizedBox(height: 270), // Adjust this value as needed
          ],
        ),
        Positioned(
          top: 290, // Adjust this value to fine-tune the position
          right: 0,
          left: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.transparent, // Set the background color
              child: CustomPaint(
                  painter: TopAppBarPainter(),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            RankCard(
                              index: 4,
                              imagePath: 'assets/profile5.png',
                              title: 'Madelyn Dias',
                              points: '590 points',
                              flagImagePath: 'assets/Flag.png',
                            ),
                            RankCard(
                              index: 5,
                              imagePath: 'assets/profile4.png',
                              title: 'Zain Vaccaro',
                              points: '448 points',
                              flagImagePath: 'assets/flag4.png',
                            ),
                            RankCard(
                              index: 6,
                              imagePath: 'assets/profile5.png',
                              title: 'Skylar Geidt',
                              points: '420 points',
                              flagImagePath: 'assets/Flag.png',
                            ),
                            RankCard(
                              index: 7,
                              imagePath: 'assets/profile5.png',
                              title: 'Skylar Geidt',
                              points: '420 points',
                              flagImagePath: 'assets/Flag.png',
                            ),
                            RankCard(
                              index: 8,
                              imagePath: 'assets/profile5.png',
                              title: 'Skylar Geidt',
                              points: '420 points',
                              flagImagePath: 'assets/Flag.png',
                            ),
                            RankCard(
                              index: 9,
                              imagePath: 'assets/profile5.png',
                              title: 'Skylar Geidt',
                              points: '420 points',
                              flagImagePath: 'assets/Flag.png',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
        Positioned(
          top: 312,
          left: (MediaQuery.of(context).size.width / 2)-4, // Center the circle horizontally
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightPurpleClr,
            ),
          ),
        ),
      ],
    );
  }
}