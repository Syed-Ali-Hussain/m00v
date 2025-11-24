import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDaLv8RYdyL19aiKD4_SOOupTMZRn1v3OA",
            authDomain: "m00v-e1849.firebaseapp.com",
            projectId: "m00v-e1849",
            storageBucket: "m00v-e1849.firebasestorage.app",
            messagingSenderId: "86428146306",
            appId: "1:86428146306:web:00ae821683f97d4a69329b",
            measurementId: "G-VF68YV20LQ"));
  } else {
    await Firebase.initializeApp();
  }
}
