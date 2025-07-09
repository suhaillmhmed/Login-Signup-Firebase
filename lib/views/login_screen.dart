import 'package:day1task/views/reset_password_screen.dart';
import 'package:day1task/views/signup_screen.dart';
import 'package:day1task/views/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  void login(BuildContext context) async {
    setState(() {
      _errorMessage = null;
    });
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields and try again';
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        setState(() {
          _errorMessage = null;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Please verify your email before logging in.';
        });
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      } else {
        setState(() {
          _errorMessage = e.message ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login", style: TextStyle(fontSize: 20.sp))),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 12.h, color: Colors.grey),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    style: TextStyle(fontSize: 17.sp),
                    onChanged: (_) {
                      if (_errorMessage != null)
                        setState(() => _errorMessage = null);
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(fontSize: 17.sp),
                    onChanged: (_) {
                      if (_errorMessage != null)
                        setState(() => _errorMessage = null);
                    },
                  ),
                  if (_errorMessage != null) ...[
                    SizedBox(height: 1.5.h),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 15.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: 100.w,
                    child: ElevatedButton(
                      onPressed: () => login(context),
                      child: Text("Login", style: TextStyle(fontSize: 18.sp)),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpScreen()),
                        ),
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResetPasswordScreen(),
                          ),
                        ),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
