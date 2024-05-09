import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/home_page.dart';
import 'package:conclave/services/api_services.dart';
import 'package:conclave/services/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:page_transition/page_transition.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  CameraController? camCtrl;
  bool loading = false;
  late TabController tabCtrl;

  List<String> imgs = [];

  int _currentIndex = 0; // Track the currently displayed container
  Future<void> _takePicture() async {
    debugPrint('line 26');
    if (camCtrl?.value.isRecordingVideo == true) {
      return;
    }

    try {
      debugPrint('line 32');
      setState(() {
        loading = true;
      });

      final XFile image = await camCtrl!.takePicture();

      debugPrint('line 39');

      addBase(image);

      // await _uploadImageToFirebase(image).whenComplete(() {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Image Captured')),
      //   );

      //   debugPrint('---------------->complete');
      setState(() {
        loading = false;
      });
      // });

      // Save the image to storage
      // await _saveImage(image.path);

      // debugPrint('Image captured and saved to ${image.path}');
    } on CameraException catch (e) {
      // Handle capture errors
      debugPrint('Error capturing image: $e');
    }
  }

  addBase(XFile file) async {
    if (file == null) {
      return null; // Handle null case (optional)
    }

    final bytes = await file.readAsBytes();
    print(base64Encode(bytes));

    var result = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 1920,
      minWidth: 1080,
      quality: 60,
      // rotate: 135,
    );
    print(bytes.length);
    print(result.length);

    imgs.add(base64Encode(result));
  }

   Future<void> addpfuserToFeatures() async {
  final docRef =
      FirebaseFirestore.instance.collection('conclaveData').doc('faceregister');
  var pf = await LocalStorageService().loadData('Pfnum') ?? '';

  print("--------------->");

  // // Check if the document exists
  // final docSnapshot = await docRef.get();
  // if (!docSnapshot.exists) {
  //   // Document doesn't exist, create it
  //   await docRef.set({}, SetOptions(merge: true)); // Create an empty document
  // }

  // Update the document with the new pf value added to the uses array
  await docRef.update({
    'uses': FieldValue.arrayUnion([pf]), // Add pf to the array
  });

}


  saveImages() async {
    var str = await ApiServices().saveImages(imgs);
    print(str.contains("succ"));
    if (str == "Registration successful") {
      print("doneeee");
      addpfuserToFeatures();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );
      camCtrl!.dispose();
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(str)),
      );
    }
  }

  void _changeContainer() {
    print("$_currentIndex------------>");
    debugPrint('line 93');
    if (_currentIndex < 3) {
      _takePicture();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image ${_currentIndex + 1} Captured')),
      );
      print(_currentIndex);
      setState(() {
        _currentIndex++;
        // _currentIndex = (_currentIndex + 1) % 4; // Cycle through containers
      });
    } else {
      saveImages();
    }
  }

  initCam() async {
    setState(() {
      loading = true;
    });
    final i = await getNumberOfImages();

    print("---------------->$i");

    final cameras = await availableCameras();
    camCtrl = CameraController(cameras[1], ResolutionPreset.low);
    camCtrl!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    setState(() {
      loading = false;
    });
    setState(() {
      loading = false;
    });
  }

  void _showWelcomePopup(BuildContext context) {
    print('rannnnnnn');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to my App!'),
        content: const Text('This is a one-time welcome message.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ); // Update flag after showing
  }

  Future<int> getNumberOfImages() async {
    final storage = FirebaseStorage.instance;
    final reference = storage.ref().child('conclaveImages/26123');

    try {
      final result = await reference.listAll();
      final items = result.items;
      print(items.length);
      return items.length;
    } catch (error) {
      print('Error getting files: $error');
      return 0; // Or handle error differently
    }
  }

  Future<void> _loadIsFirstLoad(BuildContext context) async {
    print('rannnnnnn');
    // _showWelcomePopup(context);
  }

  @override
  void initState() {
    super.initState();

    // _initializeCameras();
    initCam();
    _loadIsFirstLoad(context);
    // getNumberOfImages();
    // print(_cameraPreviews.length);
  }

  @override
  void dispose() {
    camCtrl!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // openPopup(context);
    // final mq = MediaQuery.of(context).size;

    // _loadIsFirstLoad(context);

    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pop(context);
    // });

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              !loading
                  ? Column(
                      children: [
                        // Text('capture images $_currentIndex'),

                        // _cameraPreviews[
                        //     _currentIndex], // Display the currently selected container
                        if (camCtrl != null) ...[
                          CameraPreview(camCtrl!),
                        ],

                        const SizedBox(
                            height:
                                20.0), // Add spacing between container and button
                        // ElevatedButton(
                        //   onPressed: _changeContainer,
                        //   child: const Text('capture'),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              children: [
                                imgs.isEmpty
                                    ? Container(
                                        // Wrap CircleAvatar with Container
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors
                                              .white, // Inner circle background color
                                          border: Border.all(
                                            color: Colors.black, // Border color
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors
                                              .transparent, // Make inner circle transparent
                                          radius:
                                              30.0, // Adjust radius for desired size
                                        ),
                                      )
                                    : Container(
                                        // Wrap CircleAvatar with Container
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: MemoryImage(base64Decode(imgs
                                                .last)), // Decode the base64 string
                                            fit: BoxFit
                                                .cover, // Adjust fit as needed (cover, contain, etc.)
                                          ),

                                          shape: BoxShape.circle,
                                          color: Colors
                                              .white, // Inner circle background color
                                          border: Border.all(
                                            color: Colors.black, // Border color
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: const CircleAvatar(
                                          //       child: Text(_currentIndex.toString()),
                                          backgroundColor: Colors
                                              .transparent, // Make inner circle transparent
                                          radius:
                                              30.0, // Adjust radius for desired size
                                        ),
                                      ),
                                if (imgs.isNotEmpty) ...[
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      // Wrap CircleAvatar with Container
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors
                                            .white, // Inner circle background color
                                        border: Border.all(
                                          color: Colors.black, // Border color
                                          width: 2.0, // Border width
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        child: Text(_currentIndex.toString()),
                                        backgroundColor: Colors
                                            .transparent, // Make inner circle transparent
                                        radius:
                                            10.0, // Adjust radius for desired size
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                print('line 283');
                                _changeContainer();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 84,
                                    height: 84,
                                    child: const CircleAvatar(
                                      backgroundColor:
                                          Colors.white, // Outer circle color
                                      radius:
                                          100.0, // Adjust radius for desired size
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.0, // Adjust offset for positioning
                                    left: 5.0, // Adjust offset for positioning
                                    child: Container(
                                      // Wrap CircleAvatar with Container
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors
                                            .white, // Inner circle background color
                                        border: Border.all(
                                          color: Colors.black, // Border color
                                          width: 2.0, // Border width
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors
                                            .transparent, // Make inner circle transparent
                                        radius:
                                            35.0, // Adjust radius for desired size
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   // Wrap CircleAvatar with Container
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors
                            //         .white, // Inner circle background color
                            //     border: Border.all(
                            //       color: Colors.black, // Border color
                            //       width: 2.0, // Border width
                            //     ),
                            //   ),
                            //   child: const CircleAvatar(
                            //     backgroundColor: Colors
                            //         .transparent, // Make inner circle transparent
                            //     radius: 35.0, // Adjust radius for desired size
                            //   ),
                            // ),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                ),
              ),
              if (loading) ...[
                const Center(child: CircularProgressIndicator())
              ],
            ],
          ),
        ),
      ),
    );
  }
}
