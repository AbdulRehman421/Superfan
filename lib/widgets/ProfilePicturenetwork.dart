import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
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
      ),
    );
  }
}
