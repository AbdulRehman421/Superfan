import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../pages/InfluencerDetailScreen.dart';
import '../utils/color.dart';
import '../utils/styles.dart'; // Import the Styles file

class CustomCard extends StatelessWidget {
  final int index;
  final String id;
  final String imagePath;
  final String title;
  final int followers;
  final String subtitle;
  final String flag;

  const CustomCard({
    Key? key,
    required this.index,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.followers,
    required this.subtitle,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          print('id1 $id');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => InfluencerDetailScreen(
                    influencerimage: imagePath,
                        id: id,
                      )));
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 9, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Text(index.toString(),
                        style: Styles.subtitleTextStyle(
                            fontSize: 12, height: 18 / 12, fontWeight: FontWeight.w500, color: subTxtClr)),
                  ),
                ),
                SizedBox(width: 16),
                ProfilePicture(
                   firstname: title.split(' ').first,
                  lastname: title.split(' ').last,
                  profileImagePath: imagePath,
                  flagImagePath: flag,
                  flagSize: 14,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Styles.titleTextStyle(
                          fontSize: 14,
                          height: 1.5, // Line height: 21 / 14 = 1.5
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$followers followers',
                        style: Styles.subtitleTextStyle(
                          fontSize: 14,
                          height: 1.4, // Line height: 19.6 / 14 = 1.4
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 3,
                        style: Styles.subtitleTextStyle(
                          fontSize: 8,
                          height: 1.4, // Line height: 11.2 / 8 = 1.4
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String? profileImagePath; // Changed to nullable type
  final String flagImagePath;
  final bool isFirst;
  final double profileSize;
  final double flagSize;
  final double crownSize;

  const ProfilePicture({
    required this.firstname,
    required this.lastname,
    this.profileImagePath, // Changed to nullable type
    required this.flagImagePath,
    this.isFirst = false,
    this.profileSize = 56,
    this.flagSize = 15,
    this.crownSize = 20,
    super.key,
  });

  String getInitials() {
    String initials = '';
    if (firstname.isNotEmpty) {
      initials += firstname[0];
    }
    if (lastname.isNotEmpty) {
      initials += lastname[0];
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows the crown to extend outside the bounds
      children: [
        Container(
          width: profileSize,
          height: profileSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: profileImagePath != null && profileImagePath!.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(profileImagePath!),
              fit: BoxFit.cover,
            )
                : null,
            color: profileImagePath == null || profileImagePath!.isEmpty
                ? Colors.blue
                : null,
          ),
          child: profileImagePath == null || profileImagePath!.isEmpty
              ? Center(
            child: Text(
              getInitials(),
              style: TextStyle(
                color: Colors.white,
                fontSize: profileSize / 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : null,
        ),
        if(flagImagePath.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: flagSize,
              height: flagSize,
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the flag icon container
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  flagImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        if (isFirst)
          Positioned(
            top: -crownSize / 2, // Move the crown up
            left: (profileSize - crownSize) / 2, // Center the crown on the top
            child: Container(
              width: crownSize,
              height: crownSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/crown.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
