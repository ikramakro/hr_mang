// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/employee/home.dart';
import 'package:hr_management_system/employee/signup.dart';
import 'package:hr_management_system/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class EmployeeLoginPage extends StatefulWidget {
  const EmployeeLoginPage({super.key});

  @override
  State<EmployeeLoginPage> createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  login() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgressDialogue(
            message: 'Processing please wait',
          );
        });
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) async {
      // await ZIMKit().connectUser(
      //   id: value.user!.uid,
      //   name: value.user!.email!,
      //   avatarUrl: "",
      // );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('userid1', value.user!.uid);

      sharedPreferences.setString('username1', value.user!.email!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EmployeeHomeScreen(),
        ),
      );
      Fluttertoast.showToast(msg: 'Login Sucessfully');
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: 'Error in login');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Form(
              key: _formKey,
              child: Container(
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 300,
                        width: 2000,
                        child: Image.asset("assets/images/hrbg.png"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: const Text("Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Email",
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
              controller: passwordController,
              obscureText: true,
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
                left: 220,
              ),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await login();
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Center(
                      child: Text(
                        "Login",
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
                    builder: (_) => const EmployeeSignupPage(),
                  ),
                );
              },
              child: const Text(
                "Do not have an Account? SignUp Here",
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
}
