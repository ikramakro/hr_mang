import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/owner/home_page.dart';
import 'package:hr_management_system/owner/signup.dart';
import 'package:hr_management_system/progress.dart';

class OwnerLoginPage extends StatefulWidget {
  const OwnerLoginPage({super.key});

  @override
  State<OwnerLoginPage> createState() => _OwnerLoginPageState();
}

class _OwnerLoginPageState extends State<OwnerLoginPage> {
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

  void login() {
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
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OwnerHomeScreen(),
        ),
      );
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
          child: Form(
            key: _formKey,
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
                child: const Text("Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const TextField(
                decoration: InputDecoration(
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
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
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
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login();
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
                          builder: (_) => const OnwerSignupPage()));
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
      ),
    );
  }
}
