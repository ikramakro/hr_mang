// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/employee/home.dart';
import 'package:hr_management_system/employee/login_page.dart';
import 'package:hr_management_system/progress.dart';

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
                      child: Image.asset("assets/images/hrbg.png"),
                      height: 300,
                      width: 2000,
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
                      if (nameContoller.text.length < 4) {
                        Fluttertoast.showToast(
                            msg: 'Name must br atleast 4 characters');
                      } else if (phoneContoller.text.length < 11) {
                        Fluttertoast.showToast(
                            msg: 'Number must be atleast 11 numbers');
                      } else if (!emailContoller.text.contains("@")) {
                        Fluttertoast.showToast(msg: 'Email is not valid');
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
          .then((signedInUser) => {
                FirebaseFirestore.instance
                    .collection('employees')
                    .doc(signedInUser.user!.uid)
                    .set({
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
                          Fluttertoast.showToast(
                              msg: "Account created Successfully"),
                        })
              });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Account creation failed');
    }
  }
}
