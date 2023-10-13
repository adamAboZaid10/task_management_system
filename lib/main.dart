import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/firebase_options.dart';
import 'package:projectcompany/user_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> appInitialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: appInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'app is loading',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'an error has been occurred',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Adam',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
            ),
            home: const UserState(),
          );
        });
  }
}
