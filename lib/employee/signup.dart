// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/employee/home.dart';
import 'package:hr_management_system/employee/login_page.dart';
import 'package:hr_management_system/head/signup_page.dart';
import 'package:hr_management_system/owner/signup.dart';
import 'package:hr_management_system/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSignupPage extends StatefulWidget {
  const EmployeeSignupPage({super.key});

  @override
  State<EmployeeSignupPage> createState() => _EmployeeSignupPageState();
}

class _EmployeeSignupPageState extends State<EmployeeSignupPage> {
  TextEditingController nameContoller = TextEditingController();
  TextEditingController phoneContoller = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passContoller = TextEditingController();
  TextEditingController durationContoller = TextEditingController();
  TextEditingController salaryContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: 2000,
                      child: Image.asset("assets/images/hrbg.png"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: const Text("Sign UP",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            TextField(
              controller: nameContoller,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "name",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: phoneContoller,
              maxLength: 11,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                hintText: "Phone Number",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: emailContoller,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              obscureText: true,
              controller: passContoller,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 18,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      ),
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      RegExp numericRegExp = RegExp(r'^[0-9]+$');
                      if (nameContoller.text.length < 4) {
                        Fluttertoast.showToast(
                            msg: 'Name must br atleast 4 characters');
                      } else if (!isAlpha(nameContoller.text.trim())) {
                        Fluttertoast.showToast(
                            msg: 'Name must contain only alphabets');
                      } else if (!numericRegExp.hasMatch(phoneContoller.text)) {
                        Fluttertoast.showToast(
                            msg: 'Please enter a valid numeric phone number');
                      } else if (phoneContoller.text.length < 11) {
                        Fluttertoast.showToast(
                            msg: 'Number must be atleast 11 numbers');
                      } else if (!emailContoller.text.contains("@")) {
                        Fluttertoast.showToast(msg: 'Email is not valid');
                      } else if (!strongPasswordRegExp
                          .hasMatch(passContoller.text)) {
                        Fluttertoast.showToast(
                          msg:
                              'Please enter a strong password with at least 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character',
                        );
                      } else {
                        registerEmployee();
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Center(
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EmployeeLoginPage()));
              },
              child: const Text(
                "Already login? Log In Here",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future registerEmployee() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures, unused_local_variable
    User? user = await FirebaseAuth.instance.currentUser;
    try {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialogue(
              message: 'Processing please wait',
            );
          });
      await auth
          .createUserWithEmailAndPassword(
              email: emailContoller.text, password: passContoller.text)
          .then((signedInUser) async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('userid1', signedInUser.user!.uid);

        sharedPreferences.setString('username1', signedInUser.user!.email!);
        FirebaseFirestore.instance
            .collection('employees')
            .doc(signedInUser.user!.uid)
            .set({
          'uid': signedInUser.user!.uid,
          'name': nameContoller.text,
          'phonenumber': phoneContoller.text,
          'email': emailContoller.text,
          'password': passContoller.text,
          'duration': durationContoller.text,
          'salary': salaryContoller.text,
        }).then((signedInUser) => {
                  print('Succes'),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeHomeScreen(),
                    ),
                  ),
                  Fluttertoast.showToast(msg: "Account created Successfully"),
                });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Account creation failed');
    }
  }
}
