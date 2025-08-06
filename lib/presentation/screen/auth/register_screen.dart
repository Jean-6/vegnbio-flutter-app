import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/services/auth_service.dart';
import 'package:vegnbio/dto/e_role.dart';

import '../../../core/constants/colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../dto/role.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authservice = AuthService();
  final logger = Logger();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true;
  bool isLogin = true;

  Future<void> _trySubmit() async {
    logger.i(">> Registration form submitted");

    setState(() {
      _isLoading = true;
    });

    final result = await authservice.register(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      logger.d(" >> Result : $result");

      final role = result.roles.isNotEmpty ? result.roles.first : '' as Role;
      logger.d(" >> Role after registration : $role");

      switch (role.role) {
        case ERole.CUSTOMER:
          Navigator.pushReplacementNamed(context, AppRoutes.customerDashboard);
          break;

        case ERole.SUPPLIER:
          Navigator.pushReplacementNamed(context, AppRoutes.supplierDashboard);
          break;

        default:
          Navigator.pushReplacementNamed(context, AppRoutes.register);
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
            child: Form(
              key: _formKey,
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
                    child: TextFormField(
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
                            color: Constants.greenVegnBio,
                            width: 2,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        label: Text('Pseudo'),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Constants.greenVegnBio,
                        ),
                      ),
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return 'Veuiller entrer un login';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
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
                            color: Constants.greenVegnBio,
                            width: 2,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        label: Text('Email'),
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Constants.greenVegnBio,
                        ),
                      ),
                      controller: emailController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
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
                            color: Constants.greenVegnBio,
                            width: 2,
                          ),
                        ),

                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        label: Text('Mot de passe'),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Constants.greenVegnBio,
                        ),
                      ),
                      obscureText: _isObscure,
                      controller: passwordController,
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
                            color: Constants.greenVegnBio,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.greenVegnBio,
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _trySubmit();
                              }
                            },
                            child: const Text("Ouvrir un compte"),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Vous avez déjà un compte ? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "Se connecter ",
                                style: TextStyle(
                                  color: Constants.greenVegnBio,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
