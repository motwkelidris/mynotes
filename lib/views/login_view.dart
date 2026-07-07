import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),
      ) ,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            keyboardType: TextInputType.visiblePassword,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil('/notes',(_)=>false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  dev.log('not you');
                } else if(e.code=='network-request-failed'){
                  dev.log('Check your network');
                }
                else {
                  dev.log(e.code);
                }
              }
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context,'/register');
            },
            child: Text('Register new account?'),
          ),
        ],
      ),
    );
  }
}
