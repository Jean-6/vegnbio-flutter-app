




import 'package:flutter/cupertino.dart';
import 'package:vegnbio/presentation/screen/auth/login_screen.dart';
import 'package:vegnbio/presentation/screen/auth/password_screen.dart';
import 'package:vegnbio/presentation/screen/auth/register_screen.dart';

class AppRoutes {

  static const String login = '/login';
  static const String register= '/register';
  static const String forgotPass= '/forgot-pass';
  static const String home = '/home';


  static Map<String , WidgetBuilder> routes ={
    login: (context) => const LoginScreen(),
    register: (context) =>  RegisterScreen(),
    forgotPass: (context) =>  PasswordScreen(),
  };
}