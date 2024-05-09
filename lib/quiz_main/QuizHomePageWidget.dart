import 'dart:async';
import 'dart:convert';

import 'package:conclave/custom/spacers.dart';
import 'package:conclave/quiz_main/QuizHomePageModel.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../services/storage_services.dart';


class QuizHomePageWidget extends StatefulWidget {
  const QuizHomePageWidget({super.key});

  @override
  State<QuizHomePageWidget> createState() => _QuizHomePageWidgetState();
}

class _QuizHomePageWidgetState extends State<QuizHomePageWidget> {
  late QuizHomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> quizData = [];


  String selecteds ="";
  String ans ="";
  String qId = "";
  String currentQid = "";
  int selected=-1;
  
  int pushedLiveQuiz = -1;

  Object? previousData;

  int remainingTimeInSeconds = 15;






// Create a timer variable
  late Timer timer;





  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (remainingTimeInSeconds > 0) {
        remainingTimeInSeconds--;
      } else {
        t.cancel(); // If the time is up, cancel the timer
      }
    });
    super.initState();
    _model = QuizHomePageModel();
    fetchQuizData();
    getSavedQid();

    fetchQuizLeaderBoard();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  // Create a timer that updates the remaining time every second

  Future<void> addViewToFeatures(Function()? callback) async {
    final docRef =
    FirebaseFirestore.instance.collection('conclave_live_quiz_answer').doc(qId);

    final docRef_correct =
    FirebaseFirestore.instance.collection('conclave_live_quiz_answer').doc("$qId+_correct");

    var pf = await LocalStorageService().loadData('Pfnum') ?? '';
    currentQid = qId;
    LocalStorageService().saveData('currentQid', qId!);
    // Get the current timestamp
    DateTime now = DateTime.now();

    // Format the timestamp
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    print("ssssssssss");
    print(formattedDate);
    final view = {'time_stamp': formattedDate, 'user_id': pf, 'isCorrect' : selecteds==ans ? true : false};
    final view_corerct = {'time_stamp': formattedDate, 'user_id': pf, 'isCorrect' : selecteds==ans ? true : false};

    print("--------------->");

  // Check if the document exists
  final docSnapshot = await docRef.get();
  if (!docSnapshot.exists) {
    // Document doesn't exist, create it
    await docRef.set({}, SetOptions(merge: true)); // Create an empty document
  }
    // Update the document with the new view
    await docRef.update({
      'users': FieldValue.arrayUnion([view]), // Add the view to the array
    });


    // Check if the document exists
    final docSnapshot_corr = await docRef_correct.get();
    if (!docSnapshot.exists) {
      // Document doesn't exist, create it
      await docRef_correct.set({}, SetOptions(merge: true)); // Create an empty document
    }


    // Update the document with the new view
    await docRef_correct.update({
      'users': FieldValue.arrayUnion([view_corerct]), // Add the view to the array
    });



    // Call the callback function if provided
    if (callback != null) {
      callback();
    }

  }
  @override
  Widget build(BuildContext context) {
    return



      Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: fetchQuizData(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator or placeholder widget if the connection is still waiting
                return Container(
                  color:Colors.white,
                  // child:Container(height: 50,width: 50,child: CircularProgressIndicator() )

                ); // Example loading indicator
              } else if (snapshot.hasError) {
                // Return an error widget if there's an error with the stream
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data != null && snapshot.data != previousData) {
                    // Data has changed, update your UI accordingly
                    // For example, you can call a function to handle the data change
                    handleDataChange(snapshot.data);
                    // Update the previousData variable for comparison in the next build
                    previousData = snapshot.data;
                  }
                }
                // Return your main widget tree here, utilizing the data from the stream
                return

                  GestureDetector(
                  onTap: () => _model.unfocusNode.canRequestFocus
                      ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                      : FocusScope.of(context).unfocus(),
                  child: Scaffold(
                    key: scaffoldKey,
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      top: true,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // image: DecorationImage(
                          //   fit: BoxFit.cover,
                          //   image: AssetImage(
                          //     'assets/bg_blue_new.jpeg',
                          //   ),
                          // ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_ios_new))],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Live Quiz',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const Row(
                                        //   mainAxisSize: MainAxisSize.max,
                                        //   mainAxisAlignment: MainAxisAlignment.end,
                                        //   children: [
                                        //     Padding(
                                        //       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                                        //       child: Row(
                                        //         mainAxisSize: MainAxisSize.max,
                                        //         children: [
                                        //           Icon(
                                        //             Icons.local_fire_department,
                                        //             color: Colors.deepOrange,
                                        //             size: 24,
                                        //           ),
                                        //           // Text(
                                        //           //   '00:00:00',
                                        //           //   style: TextStyle(
                                        //           //     fontFamily: 'Roboto',
                                        //           //     color: Colors.black,
                                        //           //     letterSpacing: 0,
                                        //           //     // You can adjust fontSize and fontWeight if needed
                                        //           //     // fontSize: ...,
                                        //           //     // fontWeight: ...,
                                        //           //   ),
                                        //           // ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                // color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: ListView(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics:NeverScrollableScrollPhysics(),
                                                        // scrollDirection: Axis.vertical,
                                                        children: _buildQuizWidgets(snapshot.data), // Updated here
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                              child: ElevatedButton(
                                                                onPressed:  pushedLiveQuiz == -1 ? ()  {
                                                                  print('Button pressed ...');
                                                                  print(selecteds);
                                                                  print(ans);
                                                                    addViewToFeatures((){
                                                                      // Callback function to execute after adding the view
                                                                      setState(() {
                                                                        selecteds = "";
                                                                        selecteds ="";
                                                                        ans ="";
                                                                        qId = "";
                                                                        selected=-1;
                                                                        pushedLiveQuiz = 1;

                                                                      });
                                                                    });
                                                                }:null,
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                                                  backgroundColor: const Color(0xFFE1F0FF),
                                                                  elevation: 3,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  pushedLiveQuiz == -1 ? 'Submit' : 'Done',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Readex Pro',
                                                                    color: Colors.black,
                                                                    letterSpacing: 0,
                                                                    // You may need to adjust fontSize and fontWeight according to your design
                                                                    // fontSize: ...,
                                                                    // fontWeight: ...,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    VerticalSpacer(height: 60),
                                                     buildExpandedLeaderBoard(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
            },
                ),
          ),
        ],
      );
  }

  StreamBuilder<List<Map<String, dynamic>>> buildExpandedLeaderBoard() {
    return  StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchQuizLeaderBoard(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder widget if the connection is still waiting
          return Container(
            color:Colors.white,
            // child:Container(height: 50,width: 50,child: CircularProgressIndicator() )

          ); // Example loading indicator
        } else if (snapshot.hasError) {
          // Return an error widget if there's an error with the stream
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.hasData) {
           print(snapshot.data!.length);
           print(snapshot.data![0]["name"]);
           print(snapshot.data![0]["score"]);
           print(snapshot.data![0]["image"]);

            if (snapshot.data != null && snapshot.data != previousData) {
              // Data has changed, update your UI accordingly
              // For example, you can call a function to handle the data change
              handleDataChange(snapshot.data);
              // Update the previousData variable for comparison in the next build
              previousData = snapshot.data;
            }
          }
          // Return your main widget tree here, utilizing the data from the stream
          return

          Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Container(
                              width: 100,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7467F7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Leaderboard',
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 80,
                                                          height: 80,
                                                          clipBehavior:
                                                          Clip.antiAlias,
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:  Image.memory(base64Decode(snapshot.data![1]["image"]), // Convert base64 to bytes
                                                            fit: BoxFit.cover,
                                                          ),

                                                        ),
                                                         Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![1]["name"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![1]["score"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              fontSize: 13,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          clipBehavior:
                                                          Clip.antiAlias,
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:

                                                          Image.memory(base64Decode(snapshot.data![0]["image"]

                                                        ), fit: BoxFit.cover,)),
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![0]["name"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![0]["score"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 80,
                                                          height: 80,
                                                          clipBehavior:
                                                          Clip.antiAlias,
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:
                                                          Image.memory(base64Decode(snapshot.data![2]["image"]), fit: BoxFit.cover,),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![2]["name"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 4, 0, 0),
                                                          child: Text(
                                                            snapshot.data![2]["score"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: Colors.white,
                                                              fontSize: 13,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                      ],
                    ),
                  );
        }
      },
    );


      // Expanded(
      //           child: Row(
      //             mainAxisSize: MainAxisSize.max,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Expanded(
      //                 child: Padding(
      //                   padding:
      //                   const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      //                   child: Container(
      //                     width: 100,
      //                     height: double.infinity,
      //                     decoration: const BoxDecoration(
      //                       color: Color(0xFF7467F7),
      //                       borderRadius: BorderRadius.only(
      //                         bottomLeft: Radius.circular(20),
      //                         bottomRight: Radius.circular(20),
      //                         topLeft: Radius.circular(20),
      //                         topRight: Radius.circular(20),
      //                       ),
      //                     ),
      //                     child: Column(
      //                       mainAxisSize: MainAxisSize.max,
      //                       children: [
      //                         const Padding(
      //                           padding:
      //                           EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      //                           child: Row(
      //                             mainAxisSize: MainAxisSize.max,
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Text(
      //                                 'Leaderboard',
      //                                 style: TextStyle(
      //                                   fontFamily: 'Readex Pro',
      //                                   color: Colors.white,
      //                                   fontSize: 16,
      //                                   letterSpacing: 0,
      //                                   fontWeight: FontWeight.w600,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         Expanded(
      //                           child: Row(
      //                             mainAxisSize: MainAxisSize.max,
      //                             children: [
      //                               Expanded(
      //                                 child: Column(
      //                                   mainAxisSize: MainAxisSize.max,
      //                                   children: [
      //                                     Expanded(
      //                                       child: Row(
      //                                         mainAxisSize: MainAxisSize.max,
      //                                         mainAxisAlignment:
      //                                         MainAxisAlignment.spaceEvenly,
      //                                         children: [
      //                                           Column(
      //                                             mainAxisSize: MainAxisSize.max,
      //                                             mainAxisAlignment:
      //                                             MainAxisAlignment.center,
      //                                             children: [
      //                                               Container(
      //                                                 width: 80,
      //                                                 height: 80,
      //                                                 clipBehavior:
      //                                                 Clip.antiAlias,
      //                                                 decoration: const BoxDecoration(
      //                                                   shape: BoxShape.circle,
      //                                                 ),
      //                                                 child: Image.network(
      //                                                   'https://picsum.photos/seed/431/600',
      //                                                   fit: BoxFit.cover,
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Name',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     fontSize: 14,
      //                                                     letterSpacing: 0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Score',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     fontSize: 13,
      //                                                     letterSpacing: 0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                           Column(
      //                                             mainAxisSize: MainAxisSize.max,
      //                                             mainAxisAlignment:
      //                                             MainAxisAlignment.center,
      //                                             children: [
      //                                               Container(
      //                                                 width: 100,
      //                                                 height: 100,
      //                                                 clipBehavior:
      //                                                 Clip.antiAlias,
      //                                                 decoration: const BoxDecoration(
      //                                                   shape: BoxShape.circle,
      //                                                 ),
      //                                                 child: Image.network(
      //                                                   'https://picsum.photos/seed/431/600',
      //                                                   fit: BoxFit.cover,
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Name',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     fontSize: 16,
      //                                                     letterSpacing: 0,
      //                                                     fontWeight:
      //                                                     FontWeight.w600,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Score',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     letterSpacing: 0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                           Column(
      //                                             mainAxisSize: MainAxisSize.max,
      //                                             mainAxisAlignment:
      //                                             MainAxisAlignment.center,
      //                                             children: [
      //                                               Container(
      //                                                 width: 80,
      //                                                 height: 80,
      //                                                 clipBehavior:
      //                                                 Clip.antiAlias,
      //                                                 decoration: const BoxDecoration(
      //                                                   shape: BoxShape.circle,
      //                                                 ),
      //                                                 child: Image.network(
      //                                                   'https://picsum.photos/seed/431/600',
      //                                                   fit: BoxFit.cover,
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Name',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     fontSize: 14,
      //                                                     letterSpacing: 0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               const Padding(
      //                                                 padding:
      //                                                 EdgeInsetsDirectional
      //                                                     .fromSTEB(
      //                                                     0, 4, 0, 0),
      //                                                 child: Text(
      //                                                   'Score',
      //                                                   style: TextStyle(
      //                                                     fontFamily:
      //                                                     'Readex Pro',
      //                                                     color: Colors.white,
      //                                                     fontSize: 13,
      //                                                     letterSpacing: 0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
  }
  ///
  Stream<List<Map<String, dynamic>>> fetchQuizData() {
    final CollectionReference quizCollection =
    FirebaseFirestore.instance.collection('conclave_live_quiz');

    return quizCollection.snapshots().map((querySnapshot) {
      List<Map<String, dynamic>> quizData = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = {
          'answer': doc['answer'],
          'option1': doc['option1'],
          'option2': doc['option2'],
          'option3': doc['option3'],

          'question': doc['question'],
          'quiz_id': doc['quiz_id'],
        };
        quizData.add(data);
      });

      // Print the fetched data
      quizData.forEach((quiz) {
        print('Question: ${quiz['question']}');
        print('Answer: ${quiz['answer']}');
        print('Option 1: ${quiz['option1']}');
        print('Option 2: ${quiz['option2']}');
        print('Option 3: ${quiz['option3']}');
        print('Quiz ID: ${quiz['quiz_id']}');
        print('-----------------------');

        currentQid == quiz['quiz_id'] as String ? pushedLiveQuiz = 1 : pushedLiveQuiz = -1;
      });

      return quizData;
    });
  }
  List<Widget> _buildQuizWidgets(List<Map<String, dynamic>>? data) {
    List<Widget> quizWidgets = [];
    if (data != null) {
      Map<int, dynamic> selectedOptions = {}; // Map to store selected options for each quiz item

      for (int index = 0; index < data.length; index++) {
        var quiz = data[index];


          ans = quiz['answer'];
          qId = quiz['quiz_id'];
          print(ans+"--->");

        // Create radio buttons for options
        List<Widget> optionRadioButtons = [];
        for (int i = 1; i <= 3; i++) {
        //   String optionKey = 'option$i';
          optionRadioButtons.add(
            Row(
              children: [
                Radio(
                  value: i,
                  groupValue: selected,
                  onChanged: (value) {
                    selected = value as int;
                    setState(() {
                      selecteds = quiz["option$value"];
                      ans =quiz["answer"];
                      qId = quiz["quiz_id"];
                    });
                  },
                  activeColor: Colors.amber,
                ),
                Text(quiz["option$i"], style:  TextStyle(color: Colors.black)),
              ],
            ),
          );
        }

        // Create a widget for each quiz item
        Widget quizWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question: ${quiz['question']}', style: const TextStyle(color: Colors.black)),
            // Add radio buttons for options
            ...optionRadioButtons,
            // const Divider(), // Add a divider between each quiz item
          ],
        );

        quizWidgets.add(quizWidget);
      }

      // Now you can access selected options for each quiz item
      selectedOptions.forEach((index, selectedOption) {
        print('Selected option for quiz item $index: $selectedOption');
        // Perform comparison or further processing here
      });
    }

    return quizWidgets;
  }

  void handleDataChange(List<Map<String, dynamic>>? data) {
    /// make chnages for button
  }

  Future<void> getSavedQid() async {
    currentQid = await LocalStorageService().loadData('currentQid') ?? '';
  }

  Stream<List<Map<String, dynamic>>> fetchQuizLeaderBoard() {
    final CollectionReference quizCollection =
    FirebaseFirestore.instance.collection('conclave_live_quiz_leaderboard');

    return quizCollection.snapshots().map((querySnapshot) {
      List<Map<String, dynamic>> quizDataLeaders = [];

      querySnapshot.docs.forEach((doc) {
        // Get document name
        String docName = doc.id;

        Map<String, dynamic> data = {
          'image': doc['profile_image'],
          'score': doc['score'],
          'name': doc['user_name'],
        };
        //
        // // Map document name along with data
        // Map<String, dynamic> mappedDoc = {
        //   'docName': docName,
        //   'docData': data,
        // };

        quizDataLeaders.add(data);
      });

      return quizDataLeaders;
    });
  }



}

