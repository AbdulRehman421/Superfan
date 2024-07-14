// import 'package:flutter/material.dart';
//
// class ProfilePicture extends StatelessWidget {
//   final String profileImagePath;
//   final String flagImagePath;
//   final bool isFirst;
//   final double profileSize;
//   final double flagSize;
//   final double crownSize;
//
//   const ProfilePicture({
//     required this.profileImagePath,
//     required this.flagImagePath,
//     this.isFirst = false,
//     this.profileSize = 56,
//     this.flagSize = 15  ,
//     this.crownSize = 20,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Stack(
//         clipBehavior: Clip.none, // Allows the crown to extend outside the bounds
//         children: [
//           Container(
//             // padding: EdgeInsets.only(top: 100),
//             width: profileSize,
//             height: profileSize,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: AssetImage(profileImagePath),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Container(
//               width: flagSize,
//               height: flagSize,
//               decoration: BoxDecoration(
//                 color: Colors.white, // Background color for the flag icon container
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(2),
//                 child: Image.asset(
//                   flagImagePath,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           if (isFirst)
//             Positioned(
//               top: -crownSize / 2, // Move the crown up
//               left: (profileSize - crownSize) / 2, // Center the crown on the top
//               child: Container(
//                 width: crownSize,
//                 height: crownSize,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/crown.png'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
