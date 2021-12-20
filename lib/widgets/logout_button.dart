import 'package:ecg_helpdesk/providers/auth.dart';
import 'package:ecg_helpdesk/util/authenticate.dart';
import 'package:flutter/material.dart';

TextButton logoutButton (BuildContext context) {
  return TextButton(
    onPressed: logout(context),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Icon(Icons.logout, color: Colors.white,),
    ),
  );
}

logout (BuildContext context) {
  return () {
    AuthMethods authMethods = AuthMethods();
    authMethods.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authenticate()));
  };
}
