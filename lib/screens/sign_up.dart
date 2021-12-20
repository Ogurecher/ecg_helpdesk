import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/auth.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/navigation_screen.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  const SignUp(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();

  signUserUp() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        'name': usernameTextEditingController.text,
        'email': emailTextEditingController.text
      };

      setState(() {
        isLoading = true;
      });

      await authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text);
      var user = await DatabaseMethods.addUser(userInfoMap['name']!, userInfoMap['email']!);

      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUsernameSharedPreference(userInfoMap['name']!);
      HelperFunctions.saveEmailSharedPreference(userInfoMap['email']!);
      HelperFunctions.saveUserIdSharedPreference(user.id);

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const NavigationScreen(0)
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator()),) :
        Container(
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
                      return val == null || val.isEmpty || val.length < 3 ? "Username should be at least 3 characters long" : null;
                    },
                    controller: usernameTextEditingController,
                    decoration: InputDecoration(hintText: 'username'),
                  ),
                  TextFormField(
                    validator: (val) {
                      return val == null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? "Invalid email" : null;
                    },
                    controller: emailTextEditingController,
                    decoration: InputDecoration(hintText: 'email'),
                  ),
                  TextFormField(
                    validator: (val) {
                      return val == null || val.length < 6 ? "Password should be at least 6 characters long" : null;
                    },
                    obscureText: true,
                    controller: passwordTextEditingController,
                    decoration: InputDecoration(hintText: 'password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40,),
            TextButton(
              onPressed: () {
                signUserUp();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text('Sign Up', style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Sign in now',
                      style: TextStyle(
                        color: Colors.blue,
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
