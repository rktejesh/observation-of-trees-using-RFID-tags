import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:planttag/firebase_options.dart';
import 'package:planttag/pages/choose_image.dart';
import 'package:planttag/pages/home_page.dart';
import 'package:planttag/pages/login_screen.dart';
import 'package:planttag/pages/maps_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => const GetMaterialApp(
        title: 'Image Picker Demo',
        home: Authenticate(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(360, 690),
      minTextAdapt: true,
    );
  }
}

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        print(snapshot.data.toString());
        return snapshot.data != null
            ? const DashboardScreen()
            : const LoginScreen();
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChooseImageScreen(),
    MapsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Tag',
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        iconSize: 16.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomNavigationBarItem(
              icon: "images/home.png",
              label: 'Home',
              selected: _selectedIndex == 0 ? true : false),
          _bottomNavigationBarItem(
              icon: "images/camera.png",
              label: 'Camera',
              selected: _selectedIndex == 1 ? true : false),
          _bottomNavigationBarItem(
              icon: "images/location.png",
              label: 'Maps',
              selected: _selectedIndex == 2 ? true : false),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _bottomNavigationBarItem(
      {required String icon, required String label, required bool selected}) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        scale: 1.7,
        height: 28,
        color: Colors.green,
      ),
      activeIcon: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(icon, scale: 1, height: 30, color: Colors.white),
          )),
      label: label,
    );
  }
}
