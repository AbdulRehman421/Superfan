import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:superfan/widgets/ProfilePicture.dart';
import '../utils/color.dart';
import '../utils/styles.dart';
import 'ProfilePicturenetwork.dart'; // Import the Styles file

class RankCard extends StatelessWidget {
  final int index;
  final String imagePath;
  final String title;
  final String points;
  final String flagImagePath;

  const RankCard({
    Key? key,
    required this.index,
    required this.imagePath,
    required this.title,
    required this.points,
    required this.flagImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: iconClr, width: 1.5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                      color: subTxtClr,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ProfilePicture(
                  firstname: title.split(' ').first,
                  lastname: title.split(' ').last,
                  profileImagePath: imagePath, flagImagePath: flagImagePath),
              // ClipOval(
              //   child: Image.asset(
              //     imagePath,
              //     fit: BoxFit.cover,
              //     width: 56,
              //     height: 56,
              //   ),
              // ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Styles.titleTextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          points,
                          style: Styles.subtitleTextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
