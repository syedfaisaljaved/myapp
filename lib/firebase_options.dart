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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAPwM5xFDEhjksZgxPV_AlIIcZUo71DF8',
    appId: '1:313502846172:android:8a74aeb88e5709e06f7819',
    messagingSenderId: '313502846172',
    projectId: 'rakat-tracker',
    storageBucket: 'rakat-tracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXH2M6HXtNnAk4Y8tLMyRYBd38ZcrN74U',
    appId: '1:313502846172:ios:644df5f22e0adedc6f7819',
    messagingSenderId: '313502846172',
    projectId: 'rakat-tracker',
    storageBucket: 'rakat-tracker.appspot.com',
    androidClientId: '313502846172-4d0kn81o4ih5lsc3670aqmeqb8afn284.apps.googleusercontent.com',
    iosClientId: '313502846172-qbvopc5vq5bjumn84hfdkjfos0b0k0ej.apps.googleusercontent.com',
    iosBundleId: 'com.fj.salah.rakaat.tracker',
  );
}
