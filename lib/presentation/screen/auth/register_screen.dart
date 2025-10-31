import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/domain/services/auth_service.dart';

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

      logger.d(" >> Result : $result");
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dash,
        arguments: result, // on passe l'utilisateur connecté
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Échec de connexion : identifiants incorrects")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo SVG
                  /*SvgPicture.asset(
                    "assets/images/logo.svg",
                    height: 120,
                    width: 120,
                  ),*/
                  const SizedBox(height: 20),

                  // Titre principal
                  const Text(
                    "Bienvenue sur Veg'N Bio",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Username
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre pseudo';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text('Pseudo'),
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Constants.greenVegnBio, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Email
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text('Email'),
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Constants.greenVegnBio, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text('Mot de passe'),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Constants.greenVegnBio, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPass);
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(color: Constants.greenVegnBio),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Bouton login
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.greenVegnBio,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _trySubmit();
                        }
                      },
                      child: const Text("Creer un compte"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Créer un compte
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("vous avez déjà un compte ? ", style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Constants.greenVegnBio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
