// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyBpfO6dJyH8tA2TyaUK4saAs-TPmpNHjbw',
    appId: '1:178826847352:web:1542545296132229a4798d',
    messagingSenderId: '178826847352',
    projectId: 'tinder-para-caes',
    authDomain: 'tinder-para-caes.firebaseapp.com',
    storageBucket: 'tinder-para-caes.firebasestorage.app',
    measurementId: 'G-XZDZNK2NJS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfZzuM6x-QJ0Z_vmpvh6H605p6mUi8oCQ',
    appId: '1:178826847352:android:2d31ccd83be35545a4798d',
    messagingSenderId: '178826847352',
    projectId: 'tinder-para-caes',
    storageBucket: 'tinder-para-caes.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvcnCEMBfaGOVHL5XEYS947v-_T5u2KKY',
    appId: '1:178826847352:ios:5d77c7241a963dfca4798d',
    messagingSenderId: '178826847352',
    projectId: 'tinder-para-caes',
    storageBucket: 'tinder-para-caes.firebasestorage.app',
    iosBundleId: 'com.example.tinderParaCaes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvcnCEMBfaGOVHL5XEYS947v-_T5u2KKY',
    appId: '1:178826847352:ios:5d77c7241a963dfca4798d',
    messagingSenderId: '178826847352',
    projectId: 'tinder-para-caes',
    storageBucket: 'tinder-para-caes.firebasestorage.app',
    iosBundleId: 'com.example.tinderParaCaes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBpfO6dJyH8tA2TyaUK4saAs-TPmpNHjbw',
    appId: '1:178826847352:web:20f5ace6d4263f65a4798d',
    messagingSenderId: '178826847352',
    projectId: 'tinder-para-caes',
    authDomain: 'tinder-para-caes.firebaseapp.com',
    storageBucket: 'tinder-para-caes.firebasestorage.app',
    measurementId: 'G-V8MT9LWMD9',
  );
}
