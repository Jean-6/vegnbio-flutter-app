


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/colors.dart';
import '../../../core/routes/app_routes.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState() ;

}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String login = '';
  String email = '';
  String password='';

  Future save() async{

    setState(() {
      _isLoading = true;
    });

    try{
      String name = 'dev';
      String password = 'd5008d27-bc1d-4640-af58-d5591aed8af4';
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$name:$password'))}';

      final url = Uri.parse("http://172.20.10.5:8081/api/auth/signup");

      final res = await http.post(url ,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : basicAuth,
          },
          body: json.encode({
            'username':usernameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          })
      );
      if(res.statusCode == 200){
        print('Registration successfuly');
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }else{
        print('Error when registration: ${res.statusCode}');
      }
    }catch(e){
      print('Exception: $e');
    } finally{
      setState(() {
        _isLoading = false;
      });
    }

  }

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
                        Text("Welcome To ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
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
                            validator: (value){
                              if(value == null || value.isEmpty) return 'Veuiller entrer un login';
                              return  null;
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
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Constants.greenVegnBio,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, AppRoutes.forgotPass);
                                },
                                child: Text(
                                  "Mot de passe oublié ?",style: TextStyle(color: Constants.greenVegnBio,fontSize: 14),
                                ),
                              )
                          ),
                        ),
                        SizedBox(height:30 ),
                        _isLoading? Center(child: CircularProgressIndicator()):InkWell(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              // Call server
                              save();
                            }
                          },
                          child: Container(
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
                              onPressed: () {  },
                              child: const Text("Ouvrir un compte"),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                              child: RichText(
                                  text: TextSpan(
                                      text: "Vous avez déjà un compte ? ",
                                      style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w500),
                                      children: [
                                        TextSpan(
                                          text: "Se connecter ",
                                          style: TextStyle(color: Constants.greenVegnBio, fontWeight: FontWeight.w500, fontSize: 14),
                                        )
                                      ]
                                  )),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
    )
    )
    )
    );
  }
}
