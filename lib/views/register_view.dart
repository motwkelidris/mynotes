import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/constant/routes.dart';
import 'package:firebase_project/utitities/show_error_dialog.dart';
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
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user= FirebaseAuth.instance.currentUser;
                dev.log(user.toString());
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
                //dev.log(',,,,,\n $userCredential \n ,,,,,,,,');
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, 'Existing account!');
                } else if (e.code == 'channel-error') {
                  await showErrorDialog(context, 'Fill fields!');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Type a valid email!');
                } else if (e.code == 'weak-password') {
                  await showErrorDialog(context, 'Password must be 6 size length!');
                }else{
                  await showErrorDialog(context, "Error: ${e.code}");
                }
              }catch(e){
                await showErrorDialog(context, e.toString());
              }
            },
            child: Text('Register'),
          ),
        TextButton(
          onPressed: (){
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute ,(_)=>false);
      },
      child: Text('Already have account?'),
      ),
        ],
      ),
    );
  }
}
