import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/all_products.dart';
import 'package:game_sphere_bd/screens/home_screen.dart';
import 'package:game_sphere_bd/screens/login_screen.dart';
import 'package:game_sphere_bd/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Widget Binding
  // await Firebase.initializeApp(); //Firebase Initialization
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            appId: '1:297855924061:android:4a5f2d8b2b6b6b1b',
            messagingSenderId: '297855924061',
            projectId: 'game-sphere-bd-a9cd8',
            storageBucket: 'game-sphere-bd-a9cd8.appspot.com',
            apiKey: 'AIzaSyAL5z_jSaYIqC9Tw_xsGgTL38QWEJpGK6w'));
  } on FirebaseException catch (e) {
    print('Firebase initialization error: ${e.code} - ${e.message}');
  } catch (e) {
    print('General initialization error: $e');
  }
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GameSphere BD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const LoginScreen());
        home: const HomeScreen());
    // home: const RegisterScreen());
    // home: const AllProductsScreen());
  }
}
