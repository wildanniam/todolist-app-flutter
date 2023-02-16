import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  void submitAuthForm(
      {required String email,
      required String username,
      required String password,
      required bool isLogin}) async {
    try {
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (userCredential != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'username': username,
            'email': email,
            'password' : password,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      var message = e.message ?? 'mohon periksa kembali data anda';
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(children: [
              Text(
                'todo',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 25,
              ),
              AuthForm(
                submitAuthFormfn: submitAuthForm,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
