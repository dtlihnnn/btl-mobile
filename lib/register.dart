import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/custom_text_field.dart';
import 'package:btl_mobile/login.dart';
import 'package:btl_mobile/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> countries = ['Country 1', 'Country 2', 'Country 3'];
  String selectedCountry = 'Country 1';
  bool _isPasswordVisible = false;
  FocusNode focusNode = FocusNode();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Future<void> registerAndSaveUserData(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // Thông tin người dùng đã được lưu trong Firebase Authentication
      print('User registered: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      // Thay vì Exception
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Failed with error code: ${e.code}');
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: const BackgroundImages(
            title: "Register", content: "Let's create your account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: 'Name',
                controller: _usernameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IntlPhoneField(
                  disableLengthCheck: true,
                  focusNode: focusNode,
                  showCountryFlag: false,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  languageCode: "en",
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                suffixIcon: _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("By tapping sign up you agree to the"),
                  Text(
                    " Terms and Condition",
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 0, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("and "),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 0, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(" of this app"),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    registerAndSaveUserData(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 130, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 128, 0, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
              const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
