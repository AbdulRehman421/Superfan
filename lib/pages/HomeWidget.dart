import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/Api.dart';
import '../utils/color.dart';
import '../widgets/AppBarPainter.dart';
import '../widgets/CustomCard.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<dynamic> _influencers = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await ApiClient().get(
        '${AppConstants.baseUrl}/api/v1/influencers',
        headers: {'Authorization': 'Bearer ${await AppConstants.jwttoken}'},
      );
      print('Hy Token ${AppConstants.jwttoken}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _influencers = data;
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      // Handle error gracefully, show snackbar or dialog
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 8,
                    color: primaryClr,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 8,
                    color: primaryClr,
                  ),
                ),
                CustomPaint(
                  painter: AppBarPainter(),
                  child: Container(
                    height: 70,
                  ),
                ),
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 2 - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: primaryClr,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60),
                  child: _influencers.isEmpty
                      ? Center(
                    child: _influencers.isEmpty
                        ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
                        Text('loading...',style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:primaryClr,
                        ),),
                      ],
                    ))

                        : Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
                        Text('loading...',style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:primaryClr,
                        ),)
                      ],
                    )),
                  )
                      : ListView.builder(
                    itemCount: _influencers.length,
                    itemBuilder: (context, index) {
                      final influencer = _influencers[index];
                      return CustomCard(
                        index: index + 1,
                        imagePath: influencer['profile_image_url'] ?? "", // Replace with default image path
                        title: '${influencer['first_name']} ${influencer['last_name'] ?? ''}',
                        followers: influencer['followers_count'], // Update this if you have actual followers data
                        subtitle: influencer['bio'] ?? '',
                        flag: influencer['country_flag'] ?? '', // Replace with default flag path
                        id: influencer['id'] ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
