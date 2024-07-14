import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:superfan/pages/QuizResultScreen.dart';
import 'package:superfan/services/Api.dart';
import 'package:superfan/utils/color.dart';
import 'package:superfan/utils/routes.dart';
import 'package:superfan/utils/styles.dart';
import 'package:superfan/widgets/CustomButton.dart';
import 'package:superfan/widgets/CustomOptionContainer.dart';
import 'package:superfan/widgets/CustomQuizPicContainer.dart';
import 'package:superfan/widgets/CustomTopBarContainer.dart';

class QuizScreen extends StatefulWidget {
  final String influencerId;
  final String quizCount;
  final String quizTimer;
  final String quizId;
  final String influencerImage;
  const QuizScreen({
    required this.quizCount,
    required this.quizTimer,
    required this.quizId,
    required this.influencerId,
    required this.influencerImage,
    super.key,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  List<String> questionIds = [];
  String selectedOption = "";
  String correctOption = "";
  bool _isLoading = true; // Add this line
  int index = 0;
  late int timerSeconds = 7;
  Timer? timer;
  bool loading = false;
  bool loaderLoading = false;

  @override
  void initState() {
    super.initState();
    timerSeconds = int.parse(widget.quizTimer);
    fetchQuizData();
    startTimer();
  }
  void dispose() {
    timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--; // Countdown timer decreases every second
        } else {
          timerSeconds = int.parse(widget.quizTimer); // Reset the countdown timer
          nextQuestion(); // Increment the index every 7 seconds
        }
      });
    });
  }
  void toggleLoading() async {
    setState(() {
      loaderLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      loaderLoading = false;
    });
  }
  Future<void> fetchQuizData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final jwtToken = await AppConstants.jwttoken;
      final response = await ApiClient().get(
        '${AppConstants.baseUrl}/api/v1/quiz/${widget.influencerId}',
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questions = data['questions'];
          questionIds = questions.map((question) => question['question_id'].toString()).toList();
          _isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load quiz data - ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      // Handle the error appropriately (e.g., show a message to the user)
    }
  }
  Future<void> checkAnswer(String option) async {
    if (selectedOption.isNotEmpty) {
      // Show a message to the user that an option is already selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already selected an option.'),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    setState(() {
      selectedOption = option;
      loading = true; // Start loading
    });

    try {
      final jwtToken = await AppConstants.jwttoken;
      final response = await ApiClient().post(
        '${AppConstants.baseUrl}/api/v1/quiz/check_answer',
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'quiz_id': widget.quizId,
          'question_id': questions[currentQuestionIndex]['question_id'],
          'given_option': option
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isCorrect = data['is_correct'];

        setState(() {
          correctOption = isCorrect ? option : ""; // Mark correct option if the answer is correct
          loading = false; // Stop loading
        });

        // If the answer is correct, proceed to the next question
        // if (isCorrect) {
        //   Future.delayed(Duration(seconds: 1), () {
        //     nextQuestion();
        //   });
        // }
      } else {
        throw Exception('Failed to check answer - ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking answer: $e');
      // Handle the error appropriately (e.g., show a message to the user)
      setState(() {
        loading = false; // Stop loading on error
      });
    }
  }
  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        timerSeconds =int.parse(widget.quizTimer);
        toggleLoading();
        currentQuestionIndex++;
        selectedOption = ""; // Reset the selected option for the next question
        correctOption = ""; // Reset the correct option for the next question
      });
    } else {
      // Navigate to quiz result screen and pass questionIds as arguments
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            quizCount: widget.quizCount,
            quizTimer: widget.quizTimer,
            influencerImage: widget.influencerImage,
            influencerId: widget.influencerId,
            questionIds: questionIds,
            quizId: widget.quizId,
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    print('qids : $questionIds');
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Column(
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
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        backgroundColor: primaryClr,
        body: Center(
          child: Text(
            'No Quiz Available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];
    final options = question['options'] as Map<String, dynamic>;

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: primaryClr,
            title: Text('Confirm Exit' ,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            content: Text('Are you sure you want to end the quiz? Your points will be lost!',style: TextStyle(color: Colors.white , fontSize: 18, fontWeight: FontWeight.bold),),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgimgClr2)),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Resume Quiz',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgimgClr2)),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Yes, end quiz',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
        return exit ?? false;
      },
      child: Scaffold(
        backgroundColor: primaryClr,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // First Container
                          CircleAvatar(backgroundImage: NetworkImage(widget.influencerImage),),
                          // Progress Bar
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          color: barUnfilledClr.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      Container(
                                        height: 8,
                                        width: constraints.maxWidth * ((currentQuestionIndex + 1) / questions.length),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                            ),
                          ),
                          // Second Container
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: buttonBgClr,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/Ticket.png', width: 14, height: 14),
                                SizedBox(width: 4),
                                Text('${currentQuestionIndex + 1}/${widget.quizCount}', style: Styles.navSelTextStyle()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        // Main Container
                        Container(
                          width: 400, // Adjust as needed
                          height: 400, // Adjust as needed
                          decoration: BoxDecoration(
                            color: lightbgClr,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Background Image
                              Center(
                                child:
                                question['question_image'] != null ?
                                Image.network(
                                  question['question_image']!,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'assets/quiz.jpg',
                                  fit: BoxFit.cover,
                                ) ,
                              ),
                              // Cross Icon
                              Positioned(
                                top: 16,
                                right: 16,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: primaryClr,
                                        title: Text(
                                          'Confirm Exit',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          'Are you sure you want to end the quiz? Your points will be lost!',
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgimgClr2)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false); // Return false if user wants to resume quiz
                                                  },
                                                  child: Text(
                                                    'Resume Quiz',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgimgClr2)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true); // Return true if user wants to end quiz
                                                  },
                                                  child: Text(
                                                    'Yes, end quiz',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ).then((value) {
                                      // Handle the value returned from showDialog
                                      if (value != null && value) {
                                        Navigator.of(context).pop(true); // Return true if user wants to end quiz

                                      } else {
                                      }
                                    });
                                  },
                                  child: Icon(Icons.close, color: Colors.white),
                                ),

                              ),
                              // Timer Container
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: Container(
                                  // width: 67,
                                  // height: 30,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Adjust as needed
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(6)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xE38E031A).withOpacity(0.1),
                                        blurRadius: 11,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time, color: iconBgClr, size: 14), // Adjust size as needed
                                      SizedBox(width: 2),
                                      Text(
                                        '00:0$timerSeconds',
                                        style: Styles.navSelTextStyle(color: iconBgClr),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    loaderLoading ?Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
                        Text('loading...',style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:primaryClr,
                        ),)
                      ],
                    )):
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 14, bottom: 16),
                      child: Text(
                        question['question_text'],
                        style: Styles.navSelTextStyle(fontSize: 20, height: 26 / 14, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700),
                      ),
                    ),
                    loaderLoading ? SizedBox.shrink() :
                    Column(
                      children: options.entries.map((entry) {
                        return  GestureDetector(
                          onTap: selectedOption == entry.key ? null : () => checkAnswer(entry.key),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selectedOption == entry.key ? selectedClr : lightbgClr,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: Styles.navSelTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0),
                                    ),
                                  ),
                                  if (selectedOption == entry.key)
                                    loading
                                        ? Image.asset('assets/loader.gif',height: 25,) // Show loader while loading
                                        : Icon(
                                      selectedOption == entry.key && correctOption == entry.key ? Icons.check : Icons.close,
                                      color: selectedOption == entry.key && correctOption == entry.key ? Colors.green : Colors.red,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              loaderLoading ? SizedBox.shrink() :
              Positioned(
                bottom: 1,
                left: 1,
                right: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 20, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          nextQuestion();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Skip', style: Styles.navSelTextStyle(height: 14.06 / 12, fontWeight: FontWeight.w900, color: lightOrangeClr)),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: CustomButton(
                          onPressed: selectedOption.isEmpty || loading == true ? (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Select Option First'),duration: Duration(milliseconds: 500),),
                            );
                          } : () {
                            nextQuestion();
                          },
                          text: currentQuestionIndex == 6 ? 'Complete Quiz':'Confirm',
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}