


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/routes/app_routes.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterScreenState() ;

}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String login = '';
  String email = '';
  String password='';

  BoxDecoration customDecoration ()
  {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0,2),
          color: Colors.grey,
          blurRadius: 5,
        )],
    );
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
                        decoration:  customDecoration(),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Login",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.login,color: Constants.greenVegnBio),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration:  customDecoration(),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.mail_outline,color: Constants.greenVegnBio),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: customDecoration(),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.lock_outline,color: Constants.greenVegnBio,)
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

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> HomeScreen()),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const[
                                BoxShadow(offset: Offset(0,2), color: Colors.grey, blurRadius: 5),
                              ]
                          ),
                          child: const Center(
                            child: Text("Ouvrir un compte", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
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
                )
            )
        )
    );
  }
}