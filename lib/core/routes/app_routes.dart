import 'package:flutter/cupertino.dart';
import 'package:vegnbio/presentation/screen/auth/login_screen.dart';
import 'package:vegnbio/presentation/screen/auth/password_screen.dart';
import 'package:vegnbio/presentation/screen/auth/register_screen.dart';
import 'package:vegnbio/presentation/screen/demo/customer_dash.dart';
import 'package:vegnbio/presentation/screen/supplier/place_offer_screen.dart';

import '../../presentation/screen/demo/supplier_dash.dart';

class AppRoutes {

  static const String demo1 = '/demo1';
  static const String demo2 = '/demo2';

  static const String login = '/login';
  static const String register= '/register';
  static const String forgotPass= '/forgot-pass';
  static const String supplierDashboard = '/supplier-dashboard';
  static const String customerDashboard = '/customer-dashboard';


  static Map<String , WidgetBuilder> routes = {

    demo1: (context) =>  CustomerDash(),
    demo2: (context) =>  SupplierDash(),

    login: (context) => const LoginScreen(),
    register: (context) =>  RegisterScreen(),
    forgotPass: (context) =>  PasswordScreen(),
  };
}