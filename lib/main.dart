import 'package:flutter/material.dart';
import 'package:vegnbio/core/routes/app_routes.dart';
import 'package:vegnbio/presentation/screen/auth/login_screen.dart';
import 'package:vegnbio/presentation/screen/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon App Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,

      //home: const LoginScreen(), // <- démarre ici
    );
  }
}
