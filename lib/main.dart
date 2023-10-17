import 'package:chat_basic/screens/auth_screen.dart';
import 'package:chat_basic/screens/chat_screen.dart';
import 'package:chat_basic/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.primaryContainer,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.notoSansTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

final instance = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Basic',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: StreamBuilder<User?>(
          stream: instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 'loadingscreen'.log();
              return const LoadingScreen();
            }
            if (!snapshot.hasData || snapshot.hasError) {
              // 'AuthScreen'.log();
              return const AuthScreen();
            }
            // 'ChatScreen'.log();
            return const ChatScreen();
          }),
    );
  }
}
