import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/screens/login.dart';
import 'package:reddit_clone/routes.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Clone',
      theme: Pallete.lightModeAppTheme,
      routerDelegate:
          RoutemasterDelegate(routesBuilder: ((context) => loggedOutRoute)),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
