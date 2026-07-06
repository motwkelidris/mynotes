import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/views/login_view.dart';
import 'package:firebase_project/views/register_view.dart';
import 'package:firebase_project/views/verify_email_view.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if (user!= null){
            if(user.emailVerified){
              print('Verified email');
            }else{
              return VerifyEmailView();
            }
          }else{
            return LoginView();
          }
          return Text('Done');
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}

