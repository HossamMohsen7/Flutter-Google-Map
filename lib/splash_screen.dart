import 'package:flutter/material.dart';
import 'package:flutter_app/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Image.asset("assets/flutter-logo-768x768.jpg"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Flutter App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
