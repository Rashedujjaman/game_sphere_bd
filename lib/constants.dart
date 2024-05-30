import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  static User? currentUser = FirebaseAuth.instance.currentUser;
}
