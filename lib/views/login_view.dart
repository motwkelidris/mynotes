import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/constant/routes.dart';
import 'package:firebase_project/utitities/show_error_dialog.dart';
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
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute,(_)=>false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                   await showErrorDialog(context,'Not you',);
                } else if(e.code=='network-request-failed'){
                  await showErrorDialog(context,'Check your network');
                } else if(e.code=='invalid-email'){
                  await showErrorDialog(context,'Invalid email');
                }
                else {
                  await showErrorDialog(context, "Error: ${e.code}",);
                }
              }catch(e){
                await showErrorDialog(context, e.toString());
              }
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context,registerRoute);
            },
            child: Text('Register new account?'),
          ),
        ],
      ),
    );
  }
}

