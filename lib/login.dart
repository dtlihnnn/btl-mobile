import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/bottom_bar_layout.dart';
import 'package:btl_mobile/custom_text_field.dart';
import 'package:btl_mobile/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed in: ${userCredential.user}');
      print("Dang nhap thanh cong");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBarLayout()));
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with error code: ${e.code}');
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: const BackgroundImages(
          title: "Login",
          content: "Hi, wellcome back !",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: "Password",
                obscureText: !_isPasswordVisible,
                suffixIcon: _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStatePropertyAll(Colors.white),
                        checkColor: Color.fromARGB(255, 128, 0, 255),
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  const Text("Forgot Password ?")
                ],
              ),
              TextButton(
                onPressed: () {
                  _signIn(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 128, 0, 255),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Log in ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 20,
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "or log in with",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 10,
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/gg.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 8, 253),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/fb.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Facebook",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 128, 0, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
