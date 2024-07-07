import 'package:flutter/material.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iwm/screens/splashscreen.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppDataProvider>(
        create: (context) => AppDataProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}

// Intro
// License
// win server edition
// Intro to file sharing
// sharing files with web server
// Intro to win work group
// Intro to domains
// Intro to DisabledChipAttributes
// Intro to dns
// Open compute project
// Buffalo
