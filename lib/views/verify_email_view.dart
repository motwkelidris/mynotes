import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/constant/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify email'),),
      body: Column (
        children: [
          Text("We have send you an email verification. Please open it to verify your account."),
          Text("If you haven't recieve a verification email yet, press the button below"),
          TextButton(
              onPressed: () async {
                final user= FirebaseAuth.instance.currentUser;
                dev.log(user.toString());
                await user?.sendEmailVerification();
              },  
              child: Text('Send email verification')),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (_)=>false,);
              },
              child: Text('Restart')),
        ],
      ),
    );
  }

}
