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
        return macos;
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
    apiKey: 'AIzaSyB_Rx97vyCk_WuquRtt9sdU9Hn7o4rT5Ko',
    appId: '1:578250002980:web:ce9cdb70ef1af70514feb1',
    messagingSenderId: '578250002980',
    projectId: 'marketsnapp-7e461',
    authDomain: 'marketsnapp-7e461.firebaseapp.com',
    storageBucket: 'marketsnapp-7e461.appspot.com',
    measurementId: 'G-R199T4777V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCROQj96KtK1TD6jnP4r-62OqWJThHUsfE',
    appId: '1:578250002980:android:0653aa9f5dafc27614feb1',
    messagingSenderId: '578250002980',
    projectId: 'marketsnapp-7e461',
    storageBucket: 'marketsnapp-7e461.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKIQAUpnQYp0AQL4LoKk3e_TgMMqiGDIE',
    appId: '1:578250002980:ios:8e91aeab50fbb2ed14feb1',
    messagingSenderId: '578250002980',
    projectId: 'marketsnapp-7e461',
    storageBucket: 'marketsnapp-7e461.appspot.com',
    iosBundleId: 'com.example.marketsnapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKIQAUpnQYp0AQL4LoKk3e_TgMMqiGDIE',
    appId: '1:578250002980:ios:05fdb061adb4bf1114feb1',
    messagingSenderId: '578250002980',
    projectId: 'marketsnapp-7e461',
    storageBucket: 'marketsnapp-7e461.appspot.com',
    iosBundleId: 'com.example.marketsnapp.RunnerTests',
  );
}