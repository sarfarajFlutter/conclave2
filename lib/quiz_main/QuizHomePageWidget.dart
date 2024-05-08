import 'package:conclave/quiz_main/QuizHomePageModel.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuizHomePageWidget extends StatefulWidget {
  const QuizHomePageWidget({super.key});

  @override
  State<QuizHomePageWidget> createState() => _QuizHomePageWidgetState();
}

class _QuizHomePageWidgetState extends State<QuizHomePageWidget> {
  late QuizHomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> quizData = [];
  @override
  void initState() {
    super.initState();
    _model = QuizHomePageModel();

    fetchQuizData();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/bg_blue_new.jpeg',
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Live Quiz',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 24,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      Text(
                                        '00:00:00',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                          // You can adjust fontSize and fontWeight if needed
                                          // fontSize: ...,
                                          // fontWeight: ...,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 5, 5, 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: ListView(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                        Axis.vertical,
                                                        children: _buildQuizWidgets(), // Updated here
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 5),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      print('Button pressed ...');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: EdgeInsets.fromLTRB(
                                                          24, 0, 24, 0),
                                                      backgroundColor:
                                                      Color(0xFFE1F0FF),
                                                      elevation: 3,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Submit',
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
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
                          child: Container(
                            width: 100,
                            height: double.infinity,
                            decoration: BoxDecoration(
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
                                Padding(
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
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          'https://picsum.photos/seed/431/600',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 4, 0, 0),
                                                        child: Text(
                                                          'Name',
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
                                                          'Score',
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
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          'https://picsum.photos/seed/431/600',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 4, 0, 0),
                                                        child: Text(
                                                          'Name',
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
                                                          'Score',
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
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          'https://picsum.photos/seed/431/600',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 4, 0, 0),
                                                        child: Text(
                                                          'Name',
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
                                                          'Score',
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              20, 0, 20, 0),
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE1F0FF),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Text(
                                                'Your Rank',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w600,
                                                ),
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
      ///
    //   GestureDetector(
    //   onTap: () => _model.unfocusNode.canRequestFocus
    //       ? FocusScope.of(context).requestFocus(_model.unfocusNode)
    //       : FocusScope.of(context).unfocus(),
    //   child: Scaffold(
    //     key: scaffoldKey,
    //     backgroundColor: Colors.white,
    //     body: SafeArea(
    //       top: true,
    //       child: Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           image: DecorationImage(
    //             fit: BoxFit.cover,
    //             image: Image.asset(
    //               'assets/bg_blue_new.jpeg',
    //             ).image,
    //           ),
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.max,
    //           children: [
    //             Expanded(
    //               child: Row(
    //                 mainAxisSize: MainAxisSize.max,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     child: Column(
    //                       mainAxisSize: MainAxisSize.max,
    //                       children: [
    //                         Padding(
    //                           padding:
    //                               EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.max,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Text(
    //                                 'Live Quiz',
    //                                 style: TextStyle(
    //                                   fontFamily: 'Roboto',
    //                                   color: Colors.white,
    //                                   fontSize: 24,
    //                                   letterSpacing: 0,
    //                                   fontWeight: FontWeight.w600,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         Row(
    //                           mainAxisSize: MainAxisSize.max,
    //                           mainAxisAlignment: MainAxisAlignment.end,
    //                           children: [
    //                             Padding(
    //                               padding: EdgeInsetsDirectional.fromSTEB(
    //                                   0, 0, 25, 0),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 children: [
    //                                   Icon(
    //                                     Icons.local_fire_department,
    //                                     color: Colors.white,
    //                                     size: 24,
    //                                   ),
    //                                   Text(
    //                                     '00:00:00',
    //                                     style: TextStyle(
    //                                       fontFamily: 'Roboto',
    //                                       color: Colors.white,
    //                                       letterSpacing: 0,
    //                                       // You can adjust fontSize and fontWeight if needed
    //                                       // fontSize: ...,
    //                                       // fontWeight: ...,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Expanded(
    //                           child: Padding(
    //                             padding: EdgeInsetsDirectional.fromSTEB(
    //                                 20, 5, 20, 0),
    //                             child: Container(
    //                               width: double.infinity,
    //                               height: 100,
    //                               decoration: BoxDecoration(
    //                                 color: Colors.white,
    //                                 borderRadius: BorderRadius.only(
    //                                   bottomLeft: Radius.circular(20),
    //                                   bottomRight: Radius.circular(20),
    //                                   topLeft: Radius.circular(20),
    //                                   topRight: Radius.circular(20),
    //                                 ),
    //                               ),
    //                               child: Padding(
    //                                 padding: EdgeInsetsDirectional.fromSTEB(
    //                                     5, 5, 5, 5),
    //                                 child: Column(
    //                                   mainAxisSize: MainAxisSize.max,
    //                                   children: [
    //                                     Expanded(
    //                                       child: Row(
    //                                         mainAxisSize: MainAxisSize.max,
    //                                         children: [
    //                                           Expanded(
    //                                             child: Column(
    //                                               mainAxisSize:
    //                                                   MainAxisSize.max,
    //                                               children: [
    //                                                 Expanded(
    //                                                   child: ListView(
    //                                                     padding:
    //                                                         EdgeInsets.zero,
    //                                                     shrinkWrap: true,
    //                                                     scrollDirection:
    //                                                         Axis.vertical,
    //                                                     children: [],
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                     Padding(
    //                                       padding:
    //                                           EdgeInsetsDirectional.fromSTEB(
    //                                               0, 0, 0, 5),
    //                                       child: Row(
    //                                         mainAxisSize: MainAxisSize.max,
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         children: [
    //                                           Expanded(
    //                                             child: Padding(
    //                                               padding: EdgeInsets.fromLTRB(
    //                                                   20, 0, 20, 0),
    //                                               child: ElevatedButton(
    //                                                 onPressed: () {
    //                                                   print(
    //                                                       'Button pressed ...');
    //                                                 },
    //                                                 style: ElevatedButton
    //                                                     .styleFrom(
    //                                                   padding:
    //                                                       EdgeInsets.fromLTRB(
    //                                                           24, 0, 24, 0),
    //                                                   backgroundColor:
    //                                                       Color(0xFFE1F0FF),
    //                                                   elevation: 3,
    //                                                   shape:
    //                                                       RoundedRectangleBorder(
    //                                                     borderRadius:
    //                                                         BorderRadius
    //                                                             .circular(8),
    //                                                   ),
    //                                                 ),
    //                                                 child: Text(
    //                                                   'Submit',
    //                                                   style: TextStyle(
    //                                                     fontFamily:
    //                                                         'Readex Pro',
    //                                                     color: Colors.black,
    //                                                     letterSpacing: 0,
    //                                                     // You may need to adjust fontSize and fontWeight according to your design
    //                                                     // fontSize: ...,
    //                                                     // fontWeight: ...,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //               child: Row(
    //                 mainAxisSize: MainAxisSize.max,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Expanded(
    //                     child: Padding(
    //                       padding:
    //                           EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
    //                       child: Container(
    //                         width: 100,
    //                         height: double.infinity,
    //                         decoration: BoxDecoration(
    //                           color: Color(0xFF7467F7),
    //                           borderRadius: BorderRadius.only(
    //                             bottomLeft: Radius.circular(20),
    //                             bottomRight: Radius.circular(20),
    //                             topLeft: Radius.circular(20),
    //                             topRight: Radius.circular(20),
    //                           ),
    //                         ),
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.max,
    //                           children: [
    //                             Padding(
    //                               padding: EdgeInsetsDirectional.fromSTEB(
    //                                   0, 20, 0, 0),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     'Leaderboard',
    //                                     style: TextStyle(
    //                                       fontFamily: 'Readex Pro',
    //                                       color: Colors.white,
    //                                       fontSize: 16,
    //                                       letterSpacing: 0,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             Expanded(
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 children: [
    //                                   Expanded(
    //                                     child: Column(
    //                                       mainAxisSize: MainAxisSize.max,
    //                                       children: [
    //                                         Expanded(
    //                                           child: Row(
    //                                             mainAxisSize: MainAxisSize.max,
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment
    //                                                     .spaceEvenly,
    //                                             children: [
    //                                               Column(
    //                                                 mainAxisSize:
    //                                                     MainAxisSize.max,
    //                                                 mainAxisAlignment:
    //                                                     MainAxisAlignment
    //                                                         .center,
    //                                                 children: [
    //                                                   Container(
    //                                                     width: 80,
    //                                                     height: 80,
    //                                                     clipBehavior:
    //                                                         Clip.antiAlias,
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       shape:
    //                                                           BoxShape.circle,
    //                                                     ),
    //                                                     child: Image.network(
    //                                                       'https://picsum.photos/seed/431/600',
    //                                                       fit: BoxFit.cover,
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Name',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         fontSize: 14,
    //                                                         letterSpacing: 0,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Score',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         fontSize: 13,
    //                                                         letterSpacing: 0,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                               Column(
    //                                                 mainAxisSize:
    //                                                     MainAxisSize.max,
    //                                                 mainAxisAlignment:
    //                                                     MainAxisAlignment
    //                                                         .center,
    //                                                 children: [
    //                                                   Container(
    //                                                     width: 100,
    //                                                     height: 100,
    //                                                     clipBehavior:
    //                                                         Clip.antiAlias,
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       shape:
    //                                                           BoxShape.circle,
    //                                                     ),
    //                                                     child: Image.network(
    //                                                       'https://picsum.photos/seed/431/600',
    //                                                       fit: BoxFit.cover,
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Name',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         fontSize: 16,
    //                                                         letterSpacing: 0,
    //                                                         fontWeight:
    //                                                             FontWeight.w600,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Score',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         letterSpacing: 0,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                               Column(
    //                                                 mainAxisSize:
    //                                                     MainAxisSize.max,
    //                                                 mainAxisAlignment:
    //                                                     MainAxisAlignment
    //                                                         .center,
    //                                                 children: [
    //                                                   Container(
    //                                                     width: 80,
    //                                                     height: 80,
    //                                                     clipBehavior:
    //                                                         Clip.antiAlias,
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       shape:
    //                                                           BoxShape.circle,
    //                                                     ),
    //                                                     child: Image.network(
    //                                                       'https://picsum.photos/seed/431/600',
    //                                                       fit: BoxFit.cover,
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Name',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         fontSize: 14,
    //                                                         letterSpacing: 0,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         EdgeInsetsDirectional
    //                                                             .fromSTEB(
    //                                                                 0, 4, 0, 0),
    //                                                     child: Text(
    //                                                       'Score',
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Readex Pro',
    //                                                         color: Colors.white,
    //                                                         fontSize: 13,
    //                                                         letterSpacing: 0,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: EdgeInsetsDirectional.fromSTEB(
    //                                   0, 0, 0, 10),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   Expanded(
    //                                     child: Padding(
    //                                       padding:
    //                                           EdgeInsetsDirectional.fromSTEB(
    //                                               20, 0, 20, 0),
    //                                       child: Container(
    //                                         width: 100,
    //                                         height: 40,
    //                                         decoration: BoxDecoration(
    //                                           color: Color(0xFFE1F0FF),
    //                                           borderRadius: BorderRadius.only(
    //                                             bottomLeft: Radius.circular(10),
    //                                             bottomRight:
    //                                                 Radius.circular(10),
    //                                             topLeft: Radius.circular(10),
    //                                             topRight: Radius.circular(10),
    //                                           ),
    //                                         ),
    //                                         child: Align(
    //                                           alignment:
    //                                               AlignmentDirectional(0, 0),
    //                                           child: Text(
    //                                             'Your Rank',
    //                                             textAlign: TextAlign.center,
    //                                             style: TextStyle(
    //                                               fontFamily: 'Readex Pro',
    //                                               letterSpacing: 0,
    //                                               fontWeight: FontWeight.w600,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  ///
  }




Future<List<Map<String, dynamic>>> fetchQuizData() async {
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection('conclave_live_quiz');

  try {
    QuerySnapshot querySnapshot = await quizCollection.get();
     quizData = [];

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
    });

    return quizData;
  } catch (e) {
    print('Error fetching quiz data: $e');
    return [];
  }
}

  List<Widget> _buildQuizWidgets() {
    List<Widget> quizWidgets = [];
    Map<int, String> selectedOptions = {}; // Map to store selected options for each quiz item

    // Assuming quizData is a List<Map<String, dynamic>> containing the fetched quiz data
    for (int index = 0; index < quizData.length; index++) {
      var quiz = quizData[index];

      // Create radio buttons for options
      List<Widget> optionRadioButtons = [];
      for (int i = 1; i <= 3; i++) {
        String optionKey = 'option$i';
        optionRadioButtons.add(
          Row(
            children: [
              Radio(
                value: quiz[optionKey],
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  // Update selected option for this quiz item
                  selectedOptions[index] = value;
                },
              ),
              Text(quiz[optionKey], style: TextStyle(color: Colors.black)),
            ],
          ),
        );
      }

      // Create a widget for each quiz item
      Widget quizWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question: ${quiz['question']}', style: TextStyle(color: Colors.black)),
          // Add radio buttons for options
          ...optionRadioButtons,
          Divider(), // Add a divider between each quiz item
        ],
      );

      quizWidgets.add(quizWidget);
    }

    return quizWidgets;
  }





}
