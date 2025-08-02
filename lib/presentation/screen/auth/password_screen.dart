import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/routes/app_routes.dart';
import '../home/home_screen.dart';

class PasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PasswordScreenState() ;

}

class _PasswordScreenState extends State<PasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String login = '';
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
                      Text("Welcome To ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      SizedBox(height: 25,),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
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
                            hintText: "Email",
                            /*border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.mail_outline,color: Constants.greenVegnBio),*/
                          ),
                        ),
                      ),
                      SizedBox(height:30 ),

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> HomeScreen()),
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
                              child: const Text("Envoyer")),
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: "Nouvel utilisateur ? ",
                                    style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                        text: "Ouvrir un compte",
                                        style: TextStyle(color: Constants.greenVegnBio, fontWeight: FontWeight.w500, fontSize: 14)
                                      )
                                    ]
                                )),

                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
}
