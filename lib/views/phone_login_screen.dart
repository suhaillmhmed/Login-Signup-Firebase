import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'home_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

//phone
class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false;
  String? _errorMessage;

  //phne verify
  Future<void> verifyPhoneNumber(BuildContext context) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your phone number';
        _isLoading = false;
      });
      return;
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        //verify
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _errorMessage = e.message ?? 'Error';
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  //otp
  Future<void> signInWithOtp(BuildContext context) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final otp = otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      setState(() {
        _errorMessage = 'Please enter the OTP';
        _isLoading = false;
      });
      return;
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid OTP or verification failed';
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Login", style: TextStyle(fontSize: 20.sp)),
      ),
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
                  Icon(Icons.phone_android, size: 12.h, color: Colors.grey),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number (+91...)",
                    ),
                    style: TextStyle(fontSize: 17.sp),
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                  ),
                  if (_isOtpSent) ...[
                    SizedBox(height: 2.5.h),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Enter OTP"),
                      style: TextStyle(fontSize: 17.sp),
                      onChanged: (_) {
                        if (_errorMessage != null) {
                          setState(() => _errorMessage = null);
                        }
                      },
                    ),
                  ],
                  SizedBox(height: 2.h),
                  if (!_isOtpSent)
                    SizedBox(
                      width: 100.w,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () => verifyPhoneNumber(context),
                        child:
                            _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                  "Send OTP",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                      ),
                    ),
                  if (_isOtpSent)
                    SizedBox(
                      width: 100.w,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : () => signInWithOtp(context),
                        child:
                            _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                  "Verify OTP & Login",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                      ),
                    ),
                  if (_errorMessage != null) ...[
                    SizedBox(height: 1.5.h),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 15.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
