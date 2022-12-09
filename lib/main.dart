import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:local_auth/local_auth.dart';
import 'package:spin/Provider/shared_preference.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  ExamplePageState createState() => ExamplePageState();
}

class ExamplePageState extends State<ExamplePage> {
  StreamController<int> selected = StreamController<int>();
  bool value = false;

  checkSwitch() async {
    SharedPreferenceClass().getData().then((val) {
      setState(() {
        value = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    checkSwitch();
    super.initState();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'Grogu',
      'Mace Windu',
      'Obi-Wan Kenobi',
      'Han Solo',
      'Luke Skywalker',
      'Darth Vader',
      'Yoda',
      'Ahsoka Tano',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Fortune Wheel'),
        actions: [
          Container(
            alignment: Alignment.center,
            child: Switch(
              onChanged: (val) {
                setState(() {
                  value = val;
                });
                SharedPreferenceClass().setData(value);
              },
              value: value,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected.add(
              Fortune.randomInt(0, items.length),
            );
          });
        },
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                duration: const Duration(seconds: 6),

                curve: FortuneCurve.spin,
                onAnimationEnd: () {
                  print('value');
                  // print(selected.stream);
                  // selected.onPause(){};
                },
                onAnimationStart: () {
                  print('va');
                },
                animateFirst: true,
                //styleStrategy: StyleStrategy(),
                //indicators: [],
                selected: selected.stream,
                items: [
                  for (var it in items) FortuneItem(child: Text(it)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fortune Wheel Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.blue,
          textTheme: const TextTheme(button: TextStyle(color: Colors.black))),
      darkTheme: ThemeData(
          backgroundColor: Colors.black,
          textTheme: const TextTheme(button: TextStyle(color: Colors.white))),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkData() {
    Timer(const Duration(seconds: 3), () {
      SharedPreferenceClass().getData().then((val) {
        if (val) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FingerPrintMethodScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ExamplePage()));
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkData();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Splash Screen',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cursive',
                    color: Colors.white),
              )),
        ),
      ),
    );
  }
}

class FingerPrintMethodScreen extends StatefulWidget {
  const FingerPrintMethodScreen({Key? key}) : super(key: key);

  @override
  State<FingerPrintMethodScreen> createState() =>
      _FingerPrintMethodScreenState();
}

class _FingerPrintMethodScreenState extends State<FingerPrintMethodScreen> {
  int? a;
  String? msg;

  LocalAuthentication localAuth = LocalAuthentication();

  checkAvailableMethod() async {
    bool canCheckAuth = await localAuth.canCheckBiometrics;

    if (canCheckAuth) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      print(availableBiometrics.length);
      if (Platform.isAndroid) {
        if (availableBiometrics.contains(BiometricType.face)) {
          print('face Biometric is enable ');
        }
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          print('FingerPrint Authentication is enable');
        }
        if (availableBiometrics.contains(BiometricType.strong)) {
          print('Strong Password is enable');
        }
        if (availableBiometrics.contains(BiometricType.weak)) {
          print('week password is enable');
        }
      } else if (Platform.isIOS) {
        print('here is ios Authentication Implement');
      }
    } else {
      print('No Biometric Authentication Available');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No Biometric Authentication Available')));
    }
  }

  loginWithFingerPrint() async {
    try {
      bool login = await localAuth.authenticate(
        localizedReason: "Authenticate for Testing",
        options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            useErrorDialogs: true,
            sensitiveTransaction: true),
      );
      if (login) {
        print('User is logged in successfully');
        print(login);
      } else {
        print(login);
        print('Invalid credential');
      }

      print('successfully');
    } catch (e) {
      print(e);
      print('Error occured ');
    }
  }

  loginWithFace()async{
    
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkAvailableMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FingerPrint Screen'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Available Sign in Method   $a'),
          const SizedBox(height: 25),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  maximumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                loginWithFingerPrint();
              },
              child: const Text('Login with finger print')),
          const SizedBox(height: 25),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  maximumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                loginWithFace();
              },
              child: const Text('Login with face'))
        ],
      )),
    );
  }
}
