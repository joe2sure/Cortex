import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:nb_utils/nb_utils.dart';

///firebase configs
/// Refer this Step Add Firebase Option Step from the link below
/// https://apps.iqonic.design/documentation/vizion-ai-doc/build/docs/getting-started/app/Configuration/flutter#add-firebaseoptions

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
        return firebaseConfig;
      case TargetPlatform.iOS:
        return firebaseConfig;
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

  static final FirebaseOptions firebaseConfig= FirebaseOptions(
    apiKey:'AIzaSyDFdJJCuoxeJ1fhJBk7e5KMzvj_ryX5hmg',
    appId: isIOS ? '1:680594428150:ios:9b344cfa844914d6c3dcd7':'1:680594428150:android:e311ac4f71609f92c3dcd7',
    messagingSenderId: '680594428150',
    projectId: 'vizion-ai-app',
    storageBucket: 'vizion-ai-app.appspot.com',
    iosBundleId: 'com.iqonic.vizionai',
  );
}