// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCQk-LMBiwMs4vWlwGDuX5QYGpafe-FTec',
    appId: '1:105894218706:web:34105743fc4c490313160b',
    messagingSenderId: '105894218706',
    projectId: 'baitaplon-92932',
    authDomain: 'baitaplon-92932.firebaseapp.com',
    databaseURL: 'https://baitaplon-92932-default-rtdb.firebaseio.com',
    storageBucket: 'baitaplon-92932.appspot.com',
    measurementId: 'G-CCYND0PJX9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJRfAat6ELio98f9pOUQgHGiOwsaFYxBQ',
    appId: '1:105894218706:android:3e59d85c012d17af13160b',
    messagingSenderId: '105894218706',
    projectId: 'baitaplon-92932',
    databaseURL: 'https://baitaplon-92932-default-rtdb.firebaseio.com',
    storageBucket: 'baitaplon-92932.appspot.com',
  );
}
