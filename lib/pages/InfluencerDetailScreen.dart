import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:superfan/pages/QuizScreen.dart';
import 'package:superfan/widgets/CustomButton.dart';
import 'package:superfan/widgets/InfluencerRankWidget.dart';
import 'package:superfan/widgets/ProfilePicturenetwork.dart';
import 'package:superfan/widgets/vericalDivider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/Api.dart';
import '../utils/color.dart';
import '../utils/styles.dart';
import '../widgets/backgrountStructur.dart';

class InfluencerDetailScreen extends StatefulWidget {
  final String id;
  final String influencerimage;

  const InfluencerDetailScreen({
    required this.id,
    required this.influencerimage,
    super.key,
  });

  @override
  State<InfluencerDetailScreen> createState() => _InfluencerDetailScreenState();
}

class _InfluencerDetailScreenState extends State<InfluencerDetailScreen> {
  late String _firstName = '';
  late String quiz_questions_timer = '7';
  late String quiz_questions_count = '7';
  late String points = '';
  late String worldRank = '';
  late String localRank = '';
  late String facebook = '';
  late String instagram = '';
  late String youtube =  '';
  late String x = '';
  late String _lastName = '';
  late String _bio = '';
  late String _flag = '';
  late String id = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await ApiClient().get(
        '${AppConstants.baseUrl}/api/v1/influencers/${widget.id}',
        headers: {'Authorization': 'Bearer ${await AppConstants.jwttoken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('influencer data $data');
        final influencer = data['influencer'];
        final loginData = data['logged_in_user_data'];
        print('loginData data $loginData');
        setState(() {
          quiz_questions_count = data['quiz_questions_count'] ?? '7';
          quiz_questions_timer = data['quiz_questions_timer'] ?? '7';
          _firstName = influencer['first_name'] ?? '';
          _lastName = influencer['last_name'] ?? '';
          _bio = influencer['bio'] ?? '';
          _flag = influencer['country_flag'] ?? '';
          id = influencer['id'] ?? '';
          facebook = influencer['fb_handle'] ?? '';
          instagram = influencer['insta_handle'] ?? '';
          x = influencer['x_handle'] ?? '';
          points = loginData['points'] ?? '--';
          worldRank = loginData['world_rank'] ?? '--';
          localRank = loginData['local_rank'] ?? '--';
          youtube = influencer['yt_handle'] ?? '';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error fetching influencer details data: $e');
      // Handle error gracefully, show snackbar or dialog
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _generateQuizAndNavigate() async {
    try {
      final response = await ApiClient().get(
        '${AppConstants.baseUrl}/api/v1/quiz/generate_quiz_id',
        headers: {'Authorization': 'Bearer ${await AppConstants.jwttoken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quizId = data['quiz_id'];
        print('Quiz ID: $quizId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              quizCount: quiz_questions_count,
              quizTimer: quiz_questions_timer,
              influencerImage: widget.influencerimage,
              influencerId: widget.id,
              quizId: quizId,
            ),
          ),
        );
      } else {
        throw Exception('Failed to generate quiz ID');
      }
    } catch (e) {
      print('Error generating quiz ID: $e');
      // Handle error gracefully, show snackbar or dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ids ${widget.id}');
    print('name  ${_firstName}');
    print('quiz_questions_timer  ${quiz_questions_timer}');
    print('quiz_questions_count  ${quiz_questions_count}');
    return Scaffold(
      backgroundColor: isLoading ? Colors.white:primaryClr,
      body:

      isLoading // Show loader if loading
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
              Text('loading...',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:primaryClr,
              ),)
            ],
          ))
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Background structure on top right
                  Positioned(
                    top: -60,
                    right: -60,
                    child: buildBackgroundStructure(),
                  ),
                  // Background structure on top left
                  Positioned(
                    top: 55,
                    left: -70,
                    child: buildBackgroundStructure(),
                  ),
                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16), // Space before the top container
                      // Top container with icons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 92), // Space before the main container
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          clipBehavior: Clip.none, // Allow the ProfilePicture to overflow
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  SizedBox(height: 48), // Space for the profile picture
                                  // Title
                                  Text(
                                    '${_firstName} ${_lastName}',
                                    style: Styles.titleTextStyle(fontSize: 24, height: 1.5),
                                  ),
                                  SizedBox(height: 10),
                                  // Subtitle
                                  Text(
                                    _bio,
                                    style: Styles.subtitleTextStyle(fontSize: 10, height: 1.4),
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 22),
                                  // Features container
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: primaryClr,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildFeatureItem('assets/startIcon.png', 'POINTS', points.toString()),
                                        verticalDivider(),
                                        _buildFeatureItem('assets/worldIcon.png', 'WORLD RANK', worldRank.toString()),
                                        verticalDivider(),
                                        _buildFeatureItem('assets/localRankIcon.png', 'LOCAL RANK', localRank.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -65, // Move the profile picture higher
                              left: MediaQuery.of(context).size.width / 2 - 35,
                              child: ProfilePicture(
                                firstname: _firstName,
                                lastname: _lastName,
                                profileImagePath: widget.influencerimage,
                                flagImagePath: _flag,
                                profileSize: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7),
                      // Social media icons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if(youtube.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  launchUrl(Uri.parse(
                                      youtube),mode: LaunchMode.externalApplication);
                                });
                              },
                              child: _buildSocialMediaIcon('assets/yt-logo.png'),
                            ),
                            if(facebook.isNotEmpty)
                            GestureDetector(
                                onTap: () async {
                                setState(() {
                                  launchUrl(Uri.parse(
                                      facebook),mode: LaunchMode.externalApplication);
                                });
                                },
                                child: _buildSocialMediaIcon('assets/fb-logo.png')),
                            if(x.isNotEmpty)
                            GestureDetector(
                                onTap: () async {
                                setState(() {
                                  launchUrl(Uri.parse(
                                      x),mode: LaunchMode.externalApplication);
                                });
                                },
                                child: _buildSocialMediaIcon('assets/x-logo.png')),
                            if(instagram.isNotEmpty)
                            GestureDetector(
                                onTap: () async {
                                setState(() {
                                  launchUrl(Uri.parse(
                                      instagram),mode: LaunchMode.externalApplication);
                                });
                                },
                                child: _buildSocialMediaIcon('assets/insta-logo.png')),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      // Start Quiz button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          onPressed: _generateQuizAndNavigate,
                          text: 'Start Quiz',
                        ),
                      ),
                      SizedBox(height: 34),
                      InfluencerRankWidget(id: widget.id,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String iconPath, String title, String value) {
    return Column(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        SizedBox(height: 3),
        Text(
          title,
          style: Styles.subtitleTextStyle(
              fontSize: 12, height: 1.5, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.5)),
        ),
        Text(
          value,
          style: Styles.subtitleTextStyle(fontSize: 16, height: 1.5, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildSocialMediaIcon(String iconPath) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgContainerClr,
      ),
      child: Image.asset(
        iconPath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }
}
