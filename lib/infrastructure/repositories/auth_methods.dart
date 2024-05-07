import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
       if(email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          userType.isNotEmpty){

           UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

         UserData userData = UserData(
          email: email,
          uid: cred.user!.uid,
          userName: userName,
          userType: userType,
        );
        
       await _fireStore.collection('users').doc(cred.user!.uid).set(
              userData.toJson(),
            );
        resp = 'success';
   
       }
    } catch (err) {
      resp = err.toString();      
    }
    return resp;
  }

   Future<String> loginUser({
    required String email,
    required String password
   }) async {
    String res = "Algun error ocurrido";
     try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
      );
        res = 'success';
      } else {
         res = 'Por favor rellene los campos';
      }

       
     } catch (err) {
      res = err.toString();       
     }
     return res;


   }


}