import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                print(',,,,,\n $userCredential \n ,,,,,,,,');
              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == 'email-already-in-use') {
                  print('Existing account!');
                } else if (e.code == 'channel-error') {
                  print('Fill fields!');
                } else if (e.code == 'invalid-email') {
                  print('Type a valid email!');
                } else if (e.code == 'weak-password') {
                  print('Password must be 6 size length!');
                }
              }
            },
            child: Text('Register'),
          ),
        TextButton(
          onPressed: (){
      Navigator.pushNamed(context, '/login');
      },
      child: Text('Already have account?'),
      ),
        ],
      ),
    );
  }
}
