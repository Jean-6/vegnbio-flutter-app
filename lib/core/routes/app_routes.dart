import 'package:flutter/cupertino.dart';
import 'package:vegnbio/presentation/screen/auth/login_screen.dart';
import 'package:vegnbio/presentation/screen/auth/password_screen.dart';
import 'package:vegnbio/presentation/screen/auth/register_screen.dart';

import '../../presentation/screen/demo/dash.dart';
import '../../presentation/screen/supplier/become_supplier_screen.dart';

class AppRoutes {

  static const String login = '/login';
  static const String register= '/register';
  static const String forgotPass= '/forgot-pass';
  static const String becomeSupplier = '/become-supplier';
  static const String dash = '/main-dashboard';


  static Map<String , WidgetBuilder> routes = {
    becomeSupplier: (context) => BecomeSupplier(),
    dash: (context) => Dash(),
    login: (context) => const LoginScreen(),
    register: (context) =>  RegisterScreen(),
    forgotPass: (context) =>  PasswordScreen(),
  };
}