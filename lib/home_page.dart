import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/constants/constants.dart';
import 'package:conclave/custom/spacers.dart';
import 'package:conclave/manage_quizes.dart';
import 'package:conclave/models/feature_model.dart';
import 'package:conclave/quiz_home.dart';
import 'package:conclave/quiz_main/QuizHomePageWidget.dart';
import 'package:conclave/services/storage_services.dart';
import 'package:conclave/web_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import 'models/event_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController buttonCarouselController = CarouselController();

  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final pageUrlController = TextEditingController();

  bool admin = false;
  String name = "NA";

  List<FeatureModel> featues = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> quizes = [];
  List<String> newQuizes=[];
  List<EventDetails> questions = [];

  final targetLatitude = 48.8566;
  final targetLongitude = 2.3522;
  double? currentLatitude;
  double? currentLongitude;
  bool isWithinRadius = false;
  bool locationError = false;
  String QuizStatus='';
  bool isLive=false;


  adminCheck() async {
    print("rannn27");
    final pf = await LocalStorageService().loadData('Pfnum') ?? '';

    final docRef =
    FirebaseFirestore.instance.collection('conclaveData').doc('data');

    try {
      print("rannn34");
      final doc = await docRef.get();
      if (!doc.exists) {
        return false;
      }

      final data = doc.data();
      if (data == null || data['admins'] == null) {
        return false;
      }

      print(_checkNumberInAdmins(data['admins'], pf));

      setState(() {
        admin = _checkNumberInAdmins(data['admins'], pf);
      });
    } catch (error) {
      debugPrint(error.toString());
    }

    return true;
  }

  bool _checkNumberInAdmins(List admins, String yourNumber) {
    return admins.any((admin) => admin == yourNumber);
  }

  showNameByNumber() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final num = await LocalStorageService().loadData('mobNo') ?? '';
      final querySnapshot = await firestore
          .collection('employee_details_v2')
          .where('MobileNo', isEqualTo: num)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        final userData = docSnapshot.data();

        setState(() {
          name = userData['Name'];
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }

    // return null; // Indicate name not found
  }

  Future<void> getCurrentLocation(tarLat, tarLong, rad) async {
    final locationService = GeolocatorPlatform.instance;
    bool serviceEnabled = await locationService.isLocationServiceEnabled();

    final docRef =
    FirebaseFirestore.instance.collection('conclaveData').doc('data');
    final doc = await docRef.get();
    final data = doc.data();

    if (!serviceEnabled) {
      setState(() {
        locationError = true;
      });
      return;
    }

    LocationPermission permission = await locationService.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await locationService.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        final position = await locationService.getCurrentPosition(
            locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          print("${position.latitude},${position.longitude}");
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
          print(int.parse(data!['proxRadius']));
          isWithinRadius = Geolocator.distanceBetween(
              currentLatitude!,
              currentLongitude!,
              double.parse(data!['coords'][0]),
              double.parse(data!['coords'][1])) <=
              int.parse(data['proxRadius']);
          print(isWithinRadius);
          if (!isWithinRadius) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('you are out of the location!!'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min, // Content won't overflow
                    children: [],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'close',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          // calculateDistance(currentLatitude!,
          //         currentLongitude!, targetLatitude, targetLongitude) <=
          //     500;
        });
      } catch (e) {
        // Handle exceptions during location retrieval (show message, retry option, etc.)
        setState(() {
          locationError = true;
        });
      }
    } else {
      setState(() {
        locationError = true;
      });
    }
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Feature'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Content won't overflow
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: titleController,
                decoration: InputDecoration(
                  label: const Text(
                    "title",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  hintText: "enter feature title",
                  hintStyle: const TextStyle(
                    color: Color(0x00999999),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(8),
                  //   borderSide: BorderSide(color: secondaryColor, width: 1),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    const BorderSide(color: tertiaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              VerticalSpacer(height: 15),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: imageUrlController,
                decoration: InputDecoration(
                  label: const Text(
                    "Image url",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  hintText: "enter Image url",
                  hintStyle: const TextStyle(
                    color: Color(0x00999999),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(8),
                  //   borderSide: BorderSide(color: secondaryColor, width: 1),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    const BorderSide(color: tertiaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              VerticalSpacer(height: 15),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: pageUrlController,
                decoration: InputDecoration(
                  label: const Text(
                    "Feature url",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  hintText: "enter your 10 digit mobile number",
                  hintStyle: const TextStyle(
                    color: Color(0x00999999),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(8),
                  //   borderSide: BorderSide(color: secondaryColor, width: 1),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    const BorderSide(color: tertiaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                // print(title);
                addViewToFeatures();

                // _sendDataToApi(title, imageUrl, pageUrl);
                Navigator.pop(context); // Close the popup after sending data
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

// Future<List<QueryDocumentSnapshot>>
  getDocuments() async {
    print("fffffffffffff");
    final collectionRef2 = FirebaseFirestore.instance.collection('conclaveQuiz');
    final querySnapshot = await collectionRef2.get();
    final documents = querySnapshot.docs;
    // setState(() {
    //   quizes = documents;
    // });
    // print("rrrrrrrrrrrrr");
    // print(quizes);
    // print(documents[0]['questions'][0]['question'] + "--------->");
    ///
    ///
    ///
    ///
    ///
    newQuizes.clear();
    var collectionRef;
    for(int i=0;i<documents.length;i++)
    {
      // FirebaseFirestore.instance.collection('conclaveQuiz').doc( documents[i].id).get();
      collectionRef =
          FirebaseFirestore.instance.collection('conclaveQuiz').doc(documents[i].id);
      print("quiz1quiz1");

      final doc = await collectionRef.get();
      if (!doc.exists) {
        print("exisssssss");
        return null; // Document doesn't exist
      }else{
        print("zzzzzzz");
      }

      final data = doc.data();

      // if (data == null || data['webViews'] == null) {
      //   return []; // No views array in the document
      // }
      // Get the views list from the data
      print("kkkkkkkkk");
      print(i);
      final isLive = data!['islive'] ;
      final quzStatus=data!['status'] ;
      print("ddddddddddddddd");
      print(isLive);
      print(quzStatus);
      QuizStatus=quzStatus;
      print(QuizStatus);

      if(quzStatus=='active')
      {
        setState(() {
          newQuizes.add(documents[i].id) ;
        });
        print("rrrrrrrrrrrrr");

        print("printActive");
      }else{
        print("notActive");
      }

    }

    //  collectionRef =
    //   FirebaseFirestore.instance.collection('conclaveQuiz').doc('quiz1');
    // print("quiz1quiz1");
    //
    //   final doc = await collectionRef.get();
    //   if (!doc.exists) {
    //     print("exisssssss");
    //     return null; // Document doesn't exist
    //   }else{
    //     print("zzzzzzz");
    //   }
    //
    //   final data = doc.data();
    //
    //   // if (data == null || data['webViews'] == null) {
    //   //   return []; // No views array in the document
    //   // }
    //   // Get the views list from the data
    // print("kkkkkkkkk");
    //   final isLive = data!['islive'] ;
    //   final quzStatus=data!['status'] ;
    // print("ddddddddddddddd");
    // print(isLive);
    // print(quzStatus);
    // QuizStatus=quzStatus;
    // print(QuizStatus);
    print(newQuizes);
  }

  getTitles() async {
    final docRef =
    FirebaseFirestore.instance.collection('conclaveData').doc('Features');
    final doc = await docRef.get();
    if (!doc.exists) {
      return []; // Document doesn't exist, return empty list
    }

    final data = doc.data();
    if (data == null || data['webViews'] == null) {
      return []; // No views array in the document
    }

    // Get the views list from the data
    final views = data['webViews'] as List;

    // Extract titles from each view
    final List<FeatureModel> _features = views
        .map((view) => FeatureModel.fromJson(view as Map<String, dynamic>))
        .toList();

    print("------------------>${_features[0].title}");

    setState(() {
      featues = _features;
    });

    // return features;
  }

  Future<void> addViewToFeatures() async {
    final docRef =
    FirebaseFirestore.instance.collection('conclaveData').doc('Features');
    final title = titleController.text;
    final imageUrl = imageUrlController.text;
    final pageUrl = pageUrlController.text;
    // Create the map for the view
    final view = {'title': title, 'bgUrl': imageUrl, 'url': pageUrl};

    print("--------------->");

    // Update the document with the new view
    await docRef.update({
      'webViews': FieldValue.arrayUnion([view]), // Add the view to the array
    });
    titleController.clear();
    imageUrlController.clear();
    pageUrlController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showNameByNumber();
    adminCheck();

    getTitles();
    getEvent();
    getDocuments();

    getCurrentLocation(targetLatitude, targetLongitude, 50);
  }

  // getDocuments() async {
  //   final collectionRef =
  //   FirebaseFirestore.instance.collection('conclaveQuiz').doc(widget.quiz);
  //   final doc = await collectionRef.get();
  //   if (!doc.exists) {
  //     return null; // Document doesn't exist
  //   }
  //
  //   final data = doc.data();
  //
  //   // if (data == null || data['webViews'] == null) {
  //   //   return []; // No views array in the document
  //   // }
  //
  //   // Get the views list from the data
  //   final views = data!['questions'] as List;
  //   /// add stattus
  //
  //   // Extract titles from each view
  //   final List<Questions> _features = views
  //       .map((view) => Questions.fromJson(view as Map<String, dynamic>))
  //       .toList();
  //   setState(() {
  //     questions = _features;
  //     loading = false;
  //   });
  //
  //   print(_features[0].question.toString());
  //
  //   // return data;
  // }
  getEvent() async{
    print("getEvent");
    final docRef =
    FirebaseFirestore.instance.collection('conclaveData').doc('events');
    final doc = await docRef.get();
    if (!doc.exists) {
      print("docccccccccccccnnnnnn");
      return []; // Document doesn't exist, return empty list
    }

    final data = doc.data();
    if (data == null || data['event details'] == null) {
      print("nuuuuuuuuuu");
      return []; // No views array in the document
    }

    // Get the views list from the data
    final views = data['event details'] as List;
    print("dddddddddddddddddd");
    print(views);


    final List<EventDetails> _features = views
        .map((view) => EventDetails.fromJson(view as Map<String, dynamic>))
        .toList();


    print(_features[0].speakername);
    setState(() {
      questions = _features;
      // loading = false;
    });



    // Extract titles from each view
    // final List<FeatureModel> _features = views
    //     .map((view) => FeatureModel.fromJson(view as Map<String, dynamic>))
    //     .toList();
    //
    // print("------------------>${_features[0].title}");
    //
    // setState(() {
    //   featues = _features;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/bg_blue_new.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                stretch: false,
                automaticallyImplyLeading: false,
                onStretchTrigger: () async {
                  // Triggers when stretching
                },
                // [stretchTriggerOffset] describes the amount of overscroll that must occur
                // to trigger [onStretchTrigger]
                //
                // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
                // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
                stretchTriggerOffset: 300.0,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  // collapseMode: CollapseMode.pin,
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(
                            //     // color: Colors.orange,
                            //     child: Image.asset(
                            //       'assets/Rectangle 4965.png',
                            //       height: 40,
                            //     ),
                            //   ),
                            // ),
                            HorizontalSpacer(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hello',
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  name,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              getDocuments();
                            },
                            icon: const Icon(
                              Icons.notification_add,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Your desired column configuration
                      children: [
                        // Add your widgets here

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(2.0)),
                              ),
                              width: 40.0,
                              height: 2.0,
                              margin:
                              const EdgeInsets.only(bottom: 25.0, top: 25),
                            ),
                          ],
                        ),
                        VerticalSpacer(height: 20),
                        CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            height: 200,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.9,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.1,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: List.generate(
                            questions.length,
                                (index) => ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/greeting_bg.jpeg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left:20,right:0,top: 8 ,bottom: 8),
                                      child:
                                      Text(
                                        questions[index].eventName!,
                                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                                      ),
                                      // ),
                                    ),
                                    Divider(height: 2.0),
                                    Padding(
                                      padding:  EdgeInsets.only(left:20,right:0,top: 8 ,bottom: 8),
                                      child: Text(
                                        questions[index].description!,
                                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      color: Colors.white.withOpacity(0.20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Time: ',
                                                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                                                ),
                                                Text(
                                                  questions[index].dateTime!,
                                                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Location: ',
                                                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                                                ),
                                                Text(
                                                  questions[index].location!,
                                                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                              child: Text(
                                                questions[index].speakerDescription!,
                                                style: TextStyle(fontSize: 8.0, color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                              child: Text(
                                                questions[index].speakername!,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              questions[index].image!, // Set your image path here
                                              width: 60, // Adjust the width as needed
                                              height: 60, // Adjust the height as needed
                                              fit: BoxFit.cover, // Adjust the fit as needed
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///
                        // const SizedBox(
                        //   height: 180,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(20.0),
                        //   child: Container(
                        //     width: mq.size.width,
                        //     height: 100,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(20),
                        //       // border: Border.all(color: Color.fromRGBO(r, g, b, opacity)),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.2),
                        //           spreadRadius: 1,
                        //           blurRadius: 5,
                        //           offset: const Offset(
                        //               1, 1), // changes position of shadow
                        //         ),
                        //       ],
                        //     ),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(20.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[],
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // CarouselSlider(
                        //   carouselController: buttonCarouselController,
                        //   options: CarouselOptions(
                        //     height: 200,
                        //     aspectRatio: 16 / 9,
                        //     viewportFraction: 0.9,
                        //     initialPage: 0,
                        //     enableInfiniteScroll: true,
                        //     reverse: false,
                        //     autoPlay: true,
                        //     autoPlayInterval: const Duration(seconds: 3),
                        //     autoPlayAnimationDuration:
                        //         const Duration(milliseconds: 800),
                        //     autoPlayCurve: Curves.fastOutSlowIn,
                        //     enlargeCenterPage: true,
                        //     enlargeFactor: 0.1,
                        //
                        //     // onPageChanged: (index, reason) {
                        //     //   setState(() {
                        //     //     currentIndex = index;
                        //     //     print(currentIndex);
                        //     //   });
                        //     // },
                        //     scrollDirection: Axis.horizontal,
                        //   ),
                        //   items: [
                        //     ClipRRect(
                        //       borderRadius: BorderRadius.circular(20),
                        //       child: Container(
                        //         decoration: const BoxDecoration(
                        //           image: DecorationImage(
                        //             image:
                        //                 AssetImage('assets/greeting_bg.jpeg'),
                        //             // width: mq.size.width,
                        //             // height: 200,
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //         child:
                        //             // Column(
                        //
                        //             // children: [
                        //             Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //              Padding(
                        //               padding: EdgeInsets.all(8.0),
                        //               child: Text(
                        //
                        //                   questions[0].eventName!,
                        //                 // questions[0].,
                        //                 style: TextStyle(
                        //                     fontSize: 12.0,
                        //                     color: Colors.white),
                        //               ),
                        //             ),
                        //              Divider(height: 2.0),
                        //              Padding(
                        //               padding: EdgeInsets.all(8.0),
                        //               child: Text(
                        //                 questions[0].description!,
                        //                 // 'Get ready to boost morale and strengthen bonds! Join us for an inspiring motivation and team building session that will ignite enthusiasm and foster collaboration.',
                        //                 style: TextStyle(
                        //                     fontSize: 8.0, color: Colors.white),
                        //               ),
                        //             ),
                        //             // Divider(height: 2.0),
                        //             Container(
                        //               color: Colors.white.withOpacity(0.20),
                        //               child:  Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   Padding(
                        //                     padding: EdgeInsets.all(8.0),
                        //                     child: Row(
                        //                       children: [
                        //                         Text(
                        //                           'Time: ',
                        //                           style: TextStyle(
                        //                               fontSize: 8.0,
                        //                               color: Colors.white),
                        //                         ),
                        //                         Text(
                        //                             questions[0].dateTime!,
                        //                           style: TextStyle(
                        //                               fontSize: 8.0,
                        //                               color: Colors.white),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   Padding(
                        //                     padding: EdgeInsets.all(8.0),
                        //                     child: Row(
                        //                       children: [
                        //                         Text(
                        //                           'Location: ',
                        //                           style: TextStyle(
                        //                               fontSize: 8.0,
                        //                               color: Colors.white),
                        //                         ),
                        //                         Text(
                        //                             questions[0].location!,
                        //                           style: TextStyle(
                        //                               fontSize: 8.0,
                        //                               color: Colors.white),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                  Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Padding(
                        //                       padding: EdgeInsets.only(
                        //                           top: 8.0, left: 8.0),
                        //                       child: Text(
                        //                           questions[0].speakerDescription!,
                        //                         style: TextStyle(
                        //                             fontSize: 8.0,
                        //                             color: Colors.white),
                        //                       ),
                        //                     ),
                        //                     Padding(
                        //                       padding: EdgeInsets.only(
                        //                           top: 8.0, left: 8.0),
                        //                       child: Text(
                        //                         questions[0].speakername!,
                        //                         // 'Joseph Annamkutty Jose',
                        //                         style: TextStyle(
                        //                             fontSize: 16.0,
                        //                             color: Colors.amber,
                        //                             fontWeight:
                        //                                 FontWeight.w600),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Container(
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     child: Image.network(
                        //                       questions[0].image!, // Set your image path here
                        //                       width:
                        //                           60, // Adjust the width as needed
                        //                       height:
                        //                           60, // Adjust the height as needed
                        //                       fit: BoxFit
                        //                           .cover, // Adjust the fit as needed
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         // ],
                        //         // ),
                        //       ),
                        //       // child: Image.asset(
                        //       //   'assets/greeting_bg.png',
                        //       //   width: mq.size.width,
                        //       //   height: 200,
                        //       //   fit: BoxFit.fill,
                        //       // ),
                        //     ),
                        //   ],
                        // ),
                        VerticalSpacer(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('Events',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                            ),
                            if (admin) ...[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     PageTransition(
                                      //         type: PageTransitionType
                                      //             .rightToLeft,
                                      //         child: ManageQuizes(
                                      //           quizes: quizes,
                                      //         )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Manage Quiz',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16)),
                                      ),
                                    )),
                              ),
                            ],
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height:
                            140.0, // Set a fixed height for the container
                            child: ListView.builder(
                              scrollDirection:
                              Axis.horizontal, // Set horizontal scrolling
                              itemCount: newQuizes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      if(newQuizes[index]=='Live Quiz')
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => QuizHomePageWidget()),
                                        );
                                      }else{
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: QuizHome(
                                                  quiz: newQuizes[index],
                                                )));
                                      }
                                    },
                                    child: Container(
                                      width: 200.0, // Set a width for each item
                                      padding: const EdgeInsets.all(10.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0), // Add spacing
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/img_quiz_vertical.jpeg"),
                                          fit: BoxFit
                                              .cover, // Adjust the image to cover the entire container
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Text(newQuizes[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('Explore',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                            ),
                            if (admin) ...[
                              GestureDetector(
                                onTap: () {
                                  _showPopup();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Add Feature',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16)),
                                      )),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height:
                            140.0, // Set a fixed height for the container
                            child: ListView.builder(
                              scrollDirection:
                              Axis.horizontal, // Set horizontal scrolling
                              itemCount: featues.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: WebPage(
                                                url: featues[index].url!,
                                                title: featues[index].title!,
                                              )));
                                    },
                                    child: Container(
                                      width: 200.0, // Set a width for each item
                                      padding: const EdgeInsets.all(10.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0), // Add spacing
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/bg_botom_two.png'),
                                          fit: BoxFit
                                              .cover, // Adjust the fit as per your requirement
                                        ),
                                      ),
                                      child: Text(featues[index].title!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        VerticalSpacer(height: 70)
                      ],
                    ),
                  ),
                ),
              ),
              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext context, int index) {
              //       return Container(
              //         color: index.isOdd ? Colors.white : Colors.black12,
              //         height: 100.0,
              //         child: Center(
              //           child: Text('$index',
              //               textScaler: const TextScaler.linear(5.0)),
              //         ),
              //       );
              //     },
              //     childCount: 20,
              //   ),
              // ),
            ],
          ),
        ]),
      ),
    );
  }
}
