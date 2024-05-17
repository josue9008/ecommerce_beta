import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/domain.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String password,
    required String userName,
    required String userType,
  }) async {
    String resp = "Algun error ocurrido";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          userType.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        if (userType == 'COMERCIO') {
          CommerceData commerceData = CommerceData(
              email: email,
              uid: cred.user!.uid,
              userName: userName,
              userType: userType,
              userPointsList: []);
          await _fireStore.collection('commerce').doc(cred.user!.uid).set(
                commerceData.toJson(),
              );
        } else {
          UserData userData = UserData(
            email: email,
            uid: cred.user!.uid,
            userName: userName,
            userType: userType,
          );
          await _fireStore.collection('user').doc(cred.user!.uid).set(
                userData.toJson(),
              );
        }

        //String collection = userType == 'COMERCIO' ? 'commerce' : 'user';

        //await _fireStore.collection(collection).doc(cred.user!.uid).set(
        //   userData.toJson(),
        // );
        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Algun error ocurrido";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Por favor rellene los campos';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      } else {
        return Future.error(
            'Inicio de sesión cancelado'); // Manejar cancelación del inicio de sesión
      }
    } catch (err) {
      return Future.error(
          'Error al iniciar sesión'); // Manejar errores de inicio de sesión
    }
  }
}
