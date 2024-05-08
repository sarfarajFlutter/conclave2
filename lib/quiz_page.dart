// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/constants/constants.dart';
import 'package:conclave/custom/spacers.dart';
import 'package:conclave/models/quiz_model.dart';
import 'package:conclave/models/score_model.dart';
import 'package:conclave/score_board.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class QuizPage extends StatefulWidget {
  final String quiz;
  const QuizPage({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  int q = 0;
  bool loading = true;
  List<Questions> questions = [];
  String selected = '';
  int selecteds = -1;

  

  getDocuments() async {
    final collectionRef =
        FirebaseFirestore.instance.collection('conclaveQuiz').doc(widget.quiz);
    final doc = await collectionRef.get();
    if (!doc.exists) {
      return null; // Document doesn't exist
    }

    final data = doc.data();

    // if (data == null || data['webViews'] == null) {
    //   return []; // No views array in the document
    // }

    // Get the views list from the data
    final views = data!['questions'] as List;

    // Extract titles from each view
    final List<Questions> _features = views
        .map((view) => Questions.fromJson(view as Map<String, dynamic>))
        .toList();
    setState(() {
      questions = _features;
      loading = false;
    });

    print(_features[0].question.toString());

    // return data;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getDocuments();
    // Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text((q + 1).toString()),
                ),
                if (questions.length > 0) ...[
                  loading ? Text('') : Text(questions[q].question ?? ''),
                ],
              ],
            ),
            if (questions.length > 0) ...[
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: questions[q].options!.length,
              //     itemBuilder: (context, index) {
              //       String option = questions[q].options![index];
              //       return Row(
              //         key: ValueKey(index), // Unique key for each radio button
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Radio(
              //             value: index,
              //             groupValue: selected,
              //             onChanged: (value) {
              //               // selectedIndex = value as int;
              //               setState(() {
              //                 selected = questions[q].options![value as int];
              //               });
              //               print(questions[q].options![value as int]);
              //             },
              //           ),
              //           Text(option),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              ///
              ///
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions[q].options!.length,
                  itemBuilder: (context, index) {
                    String option = questions[q].options![index];
                    bool isSelected =
                        selected == option; // Check if the option is selected
                    return Row(
                      key: ValueKey(index), // Unique key for each row
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Radio(
                          value: index,
                          groupValue: selecteds,
                          onChanged: (value) {
                            setState(() {
                              selecteds = value
                                  as int; // Cast value to int if necessary
                            });
                            print(selecteds);
                          },
                          activeColor: Colors.amber,
                        ),

                        Text(
                          option,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.blue
                                : null, // Change text color if selected
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],

            // const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextButton(
                      onPressed: () {
                        // setState(() {
                        //   q++;
                        // });

                        // if (q < questions.length - 1) {
                        //   if (questions[q].options![selecteds] ==
                        //       questions[q].answer) {

                        //     setState(() {
                        //       print("correct");
                        //       score++;
                        //     });
                        //   }
                        //   setState(() {
                        //     selecteds = -1;
                        //   });
                        // } else {
                        //   Navigator.pop(context);
                        //   Navigator.push(
                        //       context,
                        //       PageTransition(
                        //           type: PageTransitionType.rightToLeft,
                        //           child: ScoreBoard(
                        //             score: score,
                        //           )));
                        // }
                        if (questions[q].answer ==
                            questions[q].options![selecteds]) {
                          print("correct");
                          setState(() {
                            score++;
                          });
                        }

                        if (q >= questions.length - 1) {
                          print(score);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ScoreBoard(
                                    quiz: widget.quiz,
                                    score: score,
                                  )));
                        } else {
                          setState(() {
                            selecteds = -1;
                            q++;
                          });
                        }
                      },
                      child: q < questions.length - 1
                          ? const Text('next')
                          : const Text('Finish')),
                ),
              ],
            ),
            VerticalSpacer(height: 110)
          ],
        ),
      ),
    );
  }
}
