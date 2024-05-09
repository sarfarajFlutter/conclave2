import 'package:conclave/home_page.dart';
import 'package:flutter/material.dart';

import 'image_capture.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/storage_services.dart';


class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  @override
  void initState() {
    //nextTask();

    fetch();
    super.initState();
  }

  fetch()async{

var pf = await LocalStorageService().loadData('Pfnum') ?? '';

    fetchDataFromFirestore(pf);
  }

  nextTaskImgCapture() async {
    setState(() {
      opc = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opc = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opc = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => HomePage()));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ImageCapture()));
  }

  nextTaskLogin() async {
    setState(() {
      opc = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opc = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opc = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const ImageCapture()));
  }

  bool opc = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/greeting_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: opc ? 1 : 0,
            child: const Center(
                child: Text(
              'Welcome',
              style: TextStyle(fontSize: 50, color: Colors.grey),
            )),
          )
        ],
      ),
    );
  }


Future<void> fetchDataFromFirestore(String empId) async {
  try {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to your collection
    CollectionReference quizCollection = firestore.collection('conclaveData');

    // Reference to the document inside the collection
    DocumentSnapshot faceregisterDoc = await quizCollection.doc('faceregister').get();

    // Check if the document exists
    if (faceregisterDoc.exists) {
      // Access data in the document
      Map<String, dynamic> data = faceregisterDoc.data() as Map<String, dynamic>;
      
      // Check if "uses" field exists and is a list
      if (data.containsKey('uses') && data['uses'] is List) {
        // Convert "uses" field to a list of strings
        List<String> usesList = List<String>.from(data['uses']);
        
        // Check if empId exists in usesList
        bool empIdExists = usesList.contains(empId);
        
        if (empIdExists) {
          nextTaskLogin();
          print('Employee ID $empId exists in the "uses" array.');
        } else {
          nextTaskImgCapture();
          print('Employee ID $empId does not exist in the "uses" array.');
        }
      } else {
        print('"uses" field either does not exist or is not a list.');
      }
    } else {
      print('faceregister document does not exist');
    }

  } catch (e) {
    print('Error fetching data: $e');
  }
}



}
