import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterway/Consts.dart';
import 'package:flutterway/MainScreen%20Content/MainScreen.dart';
import 'package:flutterway/Models/usermodel.dart';
import 'package:flutterway/auth/LoginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  handleauth() {
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return MainScreen();
        } else
          return LoginScreen();
      },
    );
  }

  signout() {
    firebaseAuth.signOut();
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future createaccount(String email, password, username) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      await saveuser(UserModel(
        username: username,
        password: password,
        id: result.user!.uid,
        email: email,
        bio: "",
        followers: {},
        following: {},
        photoUrl: '',
      ));
      return true;
    }
  }

  Future login(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  getcurrentuser() {
    firebaseAuth.currentUser;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      assert(user!.uid != null);
      assert(user!.email != null);
      assert(user!.photoURL != null);
      assert(user!.displayName != null);
      assert(user!.getIdToken() != null);

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  Future saveuser(UserModel user) async {
    usercollection.doc(user.id).set(user.toMap());
    return true;
  }

  // APPBAR LOGOUT

  // GestureDetector(
  // onTap: () => Authentication.signOut(context: context).whenComplete(
  // () => Navigator.pushReplacement(
  // context,
  // MaterialPageRoute(
  // builder: (context) => LoginScreen(),
  // ),
  // ),
  // ),
  // child: Icon(
  // Icons.logout,
  // color: Colors.black,
  // ),
  // ),
}
