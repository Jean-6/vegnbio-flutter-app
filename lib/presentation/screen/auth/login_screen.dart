

import 'package:flutter/material.dart';
import 'package:vegnbio/core/routes/app_routes.dart';
import 'package:vegnbio/presentation/screen/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(offset: Offset(0, 2), color: Colors.grey, blurRadius: 5),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = '';
  String password = '';

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (isLogin) {
        print('Connexion avec $email / $password');
      } else {
        print('Inscription avec $email / $password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Text(
                  "Welcome To ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  //decoration:  customDecoration(),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      label: Text('Email'),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      label: Text('Mot de passe'),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPass);
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.greenAccent.withOpacity(0.4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: _trySubmit,
                      child: const Text("Se connecter"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Nouvel utilisateur ? ",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Creer un compte",
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        //
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
