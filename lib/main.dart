import 'package:conclave/firebase_options.dart';
import 'package:conclave/services/storage_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'credentials_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // try {
  //   FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // } catch(e) {
  //   // print("Failed to initialize Firebase: $e");
  // }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
      // Container(),

      SplashCheck(),

      // CredentialsScreen(
      //   title: "",
      // ),
    );
  }


}

class SplashCheck extends StatefulWidget {
  const SplashCheck({Key? key}) : super(key: key);

  @override
  State<SplashCheck> createState() => _SplashCheckState();
}

class _SplashCheckState extends State<SplashCheck> {

  bool checkStatus=false;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    check();


  }

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.white,);
  }
  Future<void> check() async {


    var pf = await LocalStorageService().loadData('LoginStatus') ?? '';
    if(pf=='true')
    {

      checkStatus=true;
    }
    setState(() {

    });

    Future.delayed(const Duration(seconds: 2));
    setState(() {
      if(checkStatus==false)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CredentialsScreen(
            title: "",
          )),
        );
        // CredentialsScreen(
        //   title: "",
        // ),
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }
}

