// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:conclave/custom/spacers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/models/score_model.dart';
import 'package:conclave/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:page_transition/page_transition.dart';

import 'custom/spacers.dart';
import 'services/storage_services.dart';

class QuizHome extends StatefulWidget {
  final String quiz;
  const QuizHome({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  @override
  State<QuizHome> createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  List<ScoreModel> featues = [];
  String pf = "";
  bool containsScoreFive = false;

  int ranking=0;
  getTitles() async {
    pf = await LocalStorageService().loadData('Pfnum') ?? '';

    final docRef = FirebaseFirestore.instance
        .collection('conclaveQuizAnswer')
        .doc(widget.quiz);
    final doc = await docRef.get();
    if (!doc.exists) {
      return []; // Document doesn't exist, return empty list
    }

    final data = doc.data();
    if (data == null || data['users'] == null) {
      return []; // No views array in the document
    }

    // Get the views list from the data
    final views = data['users'] as List;

    // Extract titles from each view
    final List<ScoreModel> _features = views
        .map((view) => ScoreModel.fromJson(view as Map<String, dynamic>))
        .toList();

    print("------------------>$_features");

    setState(() {
      featues = _features;
      containsScoreFive = featues.any((model) => model.empid == pf);
    });

    print(containsScoreFive);

    featues.sort((a, b) => int.parse(b.score!).compareTo(int.parse(a.score!)));
print("hhhhhqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
    print(pf);
    // Printing the sorted list

    featues.forEach((score) {
      print('Emp ID: ${score.empid}, Score: ${score.score}');

      if(score.empid==pf)
        {
          print(score.score);

        }
    });
    for(int i=0;i<featues.length;i++)
      {
        print(featues[i]);
        if(featues[i].empid==pf)
        {
          print("index");
          print(i+1);

ranking=i+1;
        }
      }

    setState(() {
      featues = featues..reversed.toList();
    });

    // return features;
  }

  @override
  void initState() {
    super.initState();
    getTitles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.quiz),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            VerticalSpacer(height: 20),
            const Text('Hi !'),
            VerticalSpacer(height: 20),
            const Center(
              child: Text(
                'Welcome to quizCorner. this section will \n have multipple choice questions \n mainly on finance and banking',
                textAlign: TextAlign.center,
              ),
            ),
            VerticalSpacer(height: 20),
            const Center(
              child: Text(
                'You will get 12 seconds to answer a question, \n Good Luck !',
                textAlign: TextAlign.center,
              ),
            ),
            VerticalSpacer(height: 20),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      const Text('Leader board'),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text("Rank"),
                      //     Text("EmpId"),
                      //   ],
                      // ),
                      VerticalSpacer(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: featues.length,
                        itemBuilder: (context, index) {
                          // String option = questions[q].options![index];
                          // bool isSelected = selected ==
                          //     option; // Check if the option is selected
                          return Row(
                            key: ValueKey(index), // Unique key for each row

                            children: [
                              if (index == 0) ...[
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/winner.png',
                                      fit: BoxFit.cover,
                                      width: 40,
                                    ),
                                  ),
                                )
                              ] else if (index == 1) ...[
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 15,
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              color: Colors.white
                                              // Change text color if selected
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ] else if (index == 2) ...[
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.brown,
                                      radius: 15,
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              color: Colors.white
                                              // Change text color if selected
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ] else ...[
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(color: Colors.blue
                                          // Change text color if selected
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                              HorizontalSpacer(width: 20),
                              Text(
                                featues[index].name!,
                                style: const TextStyle(color: Colors.blue
                                    // Change text color if selected
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )),
                ),
              ),
            )),
            Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Your Rank $ranking'),
              ),
            ),
            VerticalSpacer(height: 20),
            if (!containsScoreFive) ...[
              NeoPopTiltedButton(
                isFloating: true,
                onTapUp: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: QuizPage(
                            quiz: widget.quiz,
                          )));
                },
                decoration: const NeoPopTiltedButtonDecoration(
                  color: Color.fromRGBO(255, 235, 52, 1),
                  plunkColor: Color.fromRGBO(255, 235, 52, 1),
                  shadowColor: Color.fromRGBO(36, 36, 36, 1),
                  showShimmer: true,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 120.0,
                    vertical: 15,
                  ),
                  child: Text('Attempt Quiz'),
                ),
              ),
            ],
            VerticalSpacer(height: 10)
          ],
        ),
      ),
    );
  }
}
