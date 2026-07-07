import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/constant/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: Text('Register'),
      ),
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
                    .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                dev.log(',,,,,\n $userCredential \n ,,,,,,,,');
              } on FirebaseAuthException catch (e) {
                dev.log(e.code);
                if (e.code == 'email-already-in-use') {
                  dev.log('Existing account!');
                } else if (e.code == 'channel-error') {
                  dev.log('Fill fields!');
                } else if (e.code == 'invalid-email') {
                  dev.log('Type a valid email!');
                } else if (e.code == 'weak-password') {
                  dev.log('Password must be 6 size length!');
                }
              }
            },
            child: Text('Register'),
          ),
        TextButton(
          onPressed: (){
      Navigator.pushNamed(context, loginRoute);
      },
      child: Text('Already have account?'),
      ),
        ],
      ),
    );
  }
}
