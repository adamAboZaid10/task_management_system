import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/layout_screen/tasks_screen.dart';
import 'package:projectcompany/screens/ath/login.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.data == null) {
            print('user didn\'t login yet');
            return const LoginScreen();
          } else if (userSnapShot.hasData) {
            print('user is logged in');
            return const TasksScreen();
          } else if (userSnapShot.hasError) {
            return const Center(
              child: Text(
                'an error has been occurred',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.red,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}
