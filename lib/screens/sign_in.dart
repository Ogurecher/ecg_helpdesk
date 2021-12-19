import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/auth.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/navigation_screen.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  const SignIn(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  
  bool isLoading = false;
  QuerySnapshot? userInfoSnapshot;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        if (val != null) {
          DatabaseMethods.getUserByEmail(emailTextEditingController.text).then((val) {
            userInfoSnapshot = val;
            HelperFunctions.saveUsernameSharedPreference(userInfoSnapshot!.docs[0].get('name'));
            HelperFunctions.saveUserIdSharedPreference(userInfoSnapshot!.docs[0].id);
          });

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const NavigationScreen(0)
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return val == null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? "Invalid email" : null;
                    },
                    controller: emailTextEditingController,
                    decoration: const InputDecoration(
                      hintText: 'email'
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val == null || val.length < 6 ? "Password should be at least 6 characters long" : null;
                    },
                    controller: passwordTextEditingController,
                    decoration: const InputDecoration(
                      hintText: 'password'
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                signIn();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff007EF4),
                      Color(0xff2A75BC),
                    ]
                  ),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text('Sign In'),
              ),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      )
    );
  }
}
