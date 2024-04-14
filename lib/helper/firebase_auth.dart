import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// class FirebaseAuthHelper {
//   static Future<User?> registerUsingEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     try {
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       user = userCredential.user;
//       await user!.updateProfile(displayName: name);
//       await user.reload();
//       user = auth.currentUser;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }

//     return user;
//   }

//   static Future<User?> signInUsingEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     try {
//       UserCredential userCredential = await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       user = userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided.');
//       }
//     }

//     return user;
//   }
// }

Future<void> signInWithGoogleWeb(
  BuildContext context,
) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    //Authentication
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);

    final User currentUser = FirebaseAuth.instance.currentUser!;
    print("data${user.uid}");
    assert(user.uid == currentUser.uid);

    /// setValue(UID, currentUser.uid);
    googleSignIn.signOut();

    // await loginFromFirebase(
    //     user, LoginTypeGoogle, googleSignInAuthentication.accessToken,
    //     userType: userType);
  } else {
    throw 'Something Went Wrong';
  }
}

class AuthService {
  // Google Sing in
  singInWithGoolge() async {
    // Begain intrective sing in process
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '312732224236-8tceu8jboaqli39oo90jpuih910hvago.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? gUser = kIsWeb
        ? await googleSignIn.signInSilently()
        : await googleSignIn.signIn();

    // Obtain auth details for requtest
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create a new credition for user
    final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken!, accessToken: gAuth.accessToken!);

    // finally, lets sing in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class FireStoreDataBase {
  List countingList = [];
  final user = FirebaseAuth.instance.currentUser!;

  Future getData() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(user.uid);
      // to get data from all documents sequentially
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          countingList.add(result.data());
          // print("result data ${result.data()}");
        }
      });

      return countingList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }

  Future delteData(String id) async {
    try {
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(user.uid);
      collectionRef.doc(id).delete();
      Utils.toastMessage("Deleted");
      debugPrint("Deleted");
      return countingList;
    } catch (e) {
      Utils.toastMessage("$e");
      debugPrint("Error - $e");
      return e;
    }
  }
}

class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
    );
  }
}

/// DO avoid print calls in production code.
///
void avoidPrint(value) {
  if (kDebugMode) {
    print(value);
  }
}
