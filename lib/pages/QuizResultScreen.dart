import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:superfan/pages/ErrorScreen.dart';
import 'package:superfan/services/Api.dart';
import 'package:superfan/utils/routes.dart';
import 'package:superfan/widgets/CustomButton.dart';
import 'package:superfan/widgets/ProfilePicture.dart';
import 'package:superfan/widgets/ResultRankWidget.dart';
import '../utils/color.dart';
import '../utils/styles.dart';
import '../widgets/ProfilePicturenetwork.dart';
import '../widgets/backgrountStructur.dart';
import 'QuizScreen.dart';

class QuizResultScreen extends StatefulWidget {
  final List<String> questionIds;
  final String quizId;
  final String influencerImage;
  final String influencerId;
  final String quizCount;
  final String quizTimer;

  QuizResultScreen(
      {Key? key,
        required this.quizCount,
        required this.quizTimer,
      required this.questionIds,
      required this.influencerImage,
      required this.influencerId,
      required this.quizId})
      : super(key: key);

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  Map<String, dynamic>? resultData;
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    submitQuizResults();
  }

  Future<void> submitQuizResults() async {
    try {
      final jwtToken = await AppConstants.jwttoken;
      final response = await ApiClient().post(
        '${AppConstants.baseUrl}/api/v1/quiz/results',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'results': {
            'quiz_id': widget.quizId,
            'question_ids': widget.questionIds,
          },
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          resultData = jsonDecode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 500) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => InternalServerErrorScreen(),));
      } else if (response.statusCode == 404) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotFoundErrorScreen(),));
      } else {
        print('Failed to submit quiz results. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error submitting quiz results: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    print('Question IDs: ${widget.questionIds}');
    return Scaffold(
      backgroundColor: isLoading ? Colors.white : primaryClr,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/loader.gif',
                    height: 200,
                    alignment: Alignment.center,
                  ),
                  Text(
                    'loading...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryClr,
                    ),
                  )
                ],
              ))
            : SingleChildScrollView(
                child: Stack(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 70),
                        ProfilePicture(
                          firstname: user!.displayName?.split(' ').first ?? '',
                          lastname: user!.displayName?.split(' ').last ?? '',
                          profileImagePath: user!.photoURL ?? '',
                          flagImagePath: resultData?['influencer_detail']?['country_flag'] ?? '',
                          profileSize: 96,
                          flagSize: 28,
                        ),
                        Text(
                          user!.displayName.toString(),
                          style: Styles.titleTextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22, right: 26),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgContainerClr2,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: containerBorderClr, width: 2),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.only(left: 43, right: 37),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: Styles.titleTextStyle(
                                        fontSize: 20,
                                        height: 28 / 20,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'You have played a total ',
                                        ),
                                        TextSpan(
                                          text: '${resultData?['quiz_result']['total_quiz_this_month']} quizzes',
                                          style: TextStyle(color: primaryClr),
                                        ),
                                        TextSpan(
                                          text: ' this month!',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.43),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 144.21,
                                      width: 148,
                                      child: CircularProgressIndicator(
                                        value: (resultData?['quiz_result']['correct_answers'] ?? 0) /
                                            (num.tryParse(widget.quizCount) ?? 1), // Ensuring no division by null or zero
                                        backgroundColor: Colors.grey[300],
                                        color: primaryClr,
                                        strokeWidth: 10,
                                      ),

                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${resultData?['quiz_result']['correct_answers']}',
                                            style: Styles.heading1(color: titleClr),
                                          ),
                                          TextSpan(
                                            text: '/${widget.quizCount}\n',
                                            style: Styles.titleTextStyle(
                                              fontSize: 16,
                                              height: 24 / 16,
                                              color: lightTxtClr.withOpacity(0.5),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Correct Answers',
                                            style: Styles.subtitleTextStyle(
                                              fontSize: 14,
                                              height: 19.6 / 14,
                                              color: titleClr.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15.79),
                                Container(
                                  margin: EdgeInsets.only(left: 19, right: 16),
                                  padding: const EdgeInsets.only(left: 69.0, right: 63, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: primaryClr,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'New Rank: #',
                                            style: Styles.titleTextStyle(
                                              height: 33.6 / 24,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${resultData?['quiz_result']['new_rank']} ',
                                            style: Styles.heading1(color: orangeClr),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 17),
                                Padding(
                                  padding: const EdgeInsets.only(left: 35.0, right: 22),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.home);
                                        },
                                        child: Text(
                                          'Back to Home',
                                          style: Styles.navSelTextStyle(
                                            height: 14.06 / 12,
                                            fontWeight: FontWeight.w600,
                                            color: primaryClr,
                                          ),
                                        ),
                                      ),
                                      CustomButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizScreen(
                                                  quizCount: widget.quizCount,
                                                  quizTimer: widget.quizTimer,
                                                  influencerImage: widget.influencerImage,
                                                  quizId: widget.quizId,
                                                  influencerId: widget.influencerId,
                                                ),
                                              ));
                                        },
                                        text: 'Retake Quiz',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 33),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 34),
                        ResultRankWidget(questionIds: widget.questionIds, quizId: widget.quizId),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
