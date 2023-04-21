// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCmET3Oglncf9zLVAEr-cnvJeb2-HRH2mk',
    appId: '1:1072831646074:web:253cf0f6de0eef7ea42ec3',
    messagingSenderId: '1072831646074',
    projectId: 'planttag-2fb93',
    authDomain: 'planttag-2fb93.firebaseapp.com',
    storageBucket: 'planttag-2fb93.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5aRW9XU4ZEY_nr_zgLrgG9GQpr7Ori_0',
    appId: '1:1072831646074:android:e1324aa49883b379a42ec3',
    messagingSenderId: '1072831646074',
    projectId: 'planttag-2fb93',
    storageBucket: 'planttag-2fb93.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCr_kbyyqy9gxxZdsPqpoxLrReLXjTWbF0',
    appId: '1:1072831646074:ios:a506c8b12e38bac1a42ec3',
    messagingSenderId: '1072831646074',
    projectId: 'planttag-2fb93',
    storageBucket: 'planttag-2fb93.appspot.com',
    androidClientId: '1072831646074-ttmt51p33ns869npsp2db635ecs0eg2h.apps.googleusercontent.com',
    iosClientId: '1072831646074-ihfo323jdq5s1mrulnpqg1aqoid9o4h0.apps.googleusercontent.com',
    iosBundleId: 'com.example.planttag',
  );
}
