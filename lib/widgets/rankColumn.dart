import 'package:flutter/material.dart';
import 'package:superfan/utils/styles.dart';
import 'ProfilePicture.dart';
import 'ProfilePicturenetwork.dart';


class RankColumn extends StatelessWidget {
  final String profileImagePath;
  final String flagImagePath;
  final String rankImagePath;
  final String title;
  final String points;
  final bool isFirst;
  final bool isThird;

  const RankColumn({
    required this.profileImagePath,
    required this.flagImagePath,
    required this.rankImagePath,
    required this.title,
    required this.points,
    this.isFirst = false,
    this.isThird = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ProfilePicture(
          firstname: title.split(' ').first,
          lastname: title.split(' ').last,
          profileImagePath: profileImagePath,
          flagImagePath: flagImagePath,
          profileSize: 60,
          flagSize: 20,
          crownSize: 35,
          isFirst: isFirst,
        ),
        SizedBox(height: 8),
        Text(
          title.split(' ').first,
          style: Styles.titleTextStyle(fontSize: 16, height: 24/16, color: Colors.white),
        ),
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            points,
            style: Styles.titleTextStyle(fontSize: 12, height: 18/12, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Image.asset(
          rankImagePath,
          fit: BoxFit.cover,
        ),
        isThird? SizedBox(height: 20,) :
        SizedBox(height: 80,)
      ],
    );
  }
}