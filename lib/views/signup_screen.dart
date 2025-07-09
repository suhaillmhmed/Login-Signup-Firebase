import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void register(BuildContext context) async {
    setState(() {
      _errorMessage = null;
    });
    if (userNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields and try again';
      });
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords don't match";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      // Set displayName if user name is provided
      if (userNameController.text.trim().isNotEmpty) {
        await userCredential.user?.updateDisplayName(
          userNameController.text.trim(),
        );
      }
      // Send email verification
      await userCredential.user?.sendEmailVerification();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text('Verify your email'),
              content: Text(
                'A verification link has been sent to your email. Please verify before logging in.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context); // Back to login
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up", style: TextStyle(fontSize: 20.sp))),
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
                    controller: userNameController,
                    decoration: InputDecoration(labelText: "User Name"),
                    style: TextStyle(fontSize: 17.sp),
                    onChanged: (_) {
                      if (_errorMessage != null)
                        setState(() => _errorMessage = null);
                    },
                  ),
                  SizedBox(height: 2.5.h),
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
                  SizedBox(height: 2.5.h),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                      onPressed: () => register(context),
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 18.sp),
                      ),
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
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
