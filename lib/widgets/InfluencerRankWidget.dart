import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:superfan/utils/color.dart';
import 'package:superfan/widgets/rankColumn.dart';
import 'package:superfan/widgets/TopAppBarPainter.dart';
import 'package:superfan/widgets/rankCard.dart';

import '../services/Api.dart';

class InfluencerRankWidget extends StatefulWidget {
  final String id;

  const InfluencerRankWidget({
    required this.id,
    super.key,
  });

  @override
  State<InfluencerRankWidget> createState() => _InfluencerRankWidgetState();
}

class _InfluencerRankWidgetState extends State<InfluencerRankWidget> {
  List<Map<String, dynamic>> leaderboardTop10 = [];
  bool isLoading = true;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    final jwtToken = await AppConstants.jwttoken;
    final url = '${AppConstants.baseUrl}/api/v1/influencers/${widget.id}';
    if (jwtToken == null) {
      setState(() {
        errorMessage = 'JWT token is missing';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          leaderboardTop10 = List<Map<String, dynamic>>.from(data['leaderboard_top10']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load leaderboard data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load leaderboard data: $e';
        isLoading = false;
      });
    }
  }

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
        leaderboardTop10.isEmpty ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
            Text('loading...',style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:primaryClr,
            ),)
          ],
        )) :
        Column(
          children: [
            if (leaderboardTop10.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RankColumn(
                    profileImagePath: leaderboardTop10.length > 1 ? leaderboardTop10[1]['profile_image_url'] ?? '' : "",
                    flagImagePath: leaderboardTop10.length > 1 ? leaderboardTop10[1]['country_flag'] ?? '': "",
                    rankImagePath: 'assets/rank2.png',
                    title: leaderboardTop10.length > 1 ? '${leaderboardTop10[1]['first_name']} ${leaderboardTop10[1]['last_name']}': " No Fan",
                    points: leaderboardTop10.length > 1 ? '${leaderboardTop10[1]['points']} points': "0",
                  ),
                  RankColumn(
                    profileImagePath: leaderboardTop10.length > 0 ? leaderboardTop10[0]['profile_image_url'] ?? '': "",
                    flagImagePath: leaderboardTop10.length > 0 ? leaderboardTop10[0]['country_flag'] ?? '': "",
                    rankImagePath: 'assets/rank1.png',
                    title: leaderboardTop10.length > 0 ? '${leaderboardTop10[0]['first_name']} ${leaderboardTop10[0]['last_name']}': "No Fan",
                    points: leaderboardTop10.length > 0 ? '${leaderboardTop10[0]['points']} points': "",
                    isFirst: true,
                  ),
                  RankColumn(
                    profileImagePath: leaderboardTop10.length > 2 ? leaderboardTop10[2]['profile_image_url'] ?? '': "",
                    flagImagePath: leaderboardTop10.length > 2 ? leaderboardTop10[2]['country_flag'] ?? '': "",
                    rankImagePath: 'assets/rank3.png',
                    title: leaderboardTop10.length > 2 ? '${leaderboardTop10[2]['first_name']} ${leaderboardTop10[2]['last_name']}': "No Fan",
                    points: leaderboardTop10.length > 2 ? '${leaderboardTop10[2]['points']} points': "0",
                    isThird: true,
                  ),
                ],
              ),
            SizedBox(height: 270), // Adjust this value as needed
          ],
        ),
        leaderboardTop10.isEmpty ? SizedBox.shrink() :
        Positioned(
          top: 290,
          right: 0,
          left: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.transparent, // Set the background color
              child: CustomPaint(
                painter: TopAppBarPainter(),
                child:
                Column(
                  children: [
                    SizedBox(height: 70),
                    Expanded(child: ListView(
                      shrinkWrap: true,
                      children: [
                        if (leaderboardTop10.length > 3)
                          ...leaderboardTop10.sublist(3).asMap().entries.map((entry) {
                            int index = entry.key + 4;
                            var item = entry.value;
                            return RankCard(
                              index: index,
                              imagePath: item['profile_image_url'] ?? '',
                              title: '${item['first_name']} ${item['last_name']}',
                              points: '${item['points']} points',
                              flagImagePath: item['country_flag'] ?? '',
                            );
                          }).toList(),
                      ],
                    )),// Adjust the height as needed

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 312,
          left: (MediaQuery.of(context).size.width / 2)-4,  // Center the circle horizontally
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
