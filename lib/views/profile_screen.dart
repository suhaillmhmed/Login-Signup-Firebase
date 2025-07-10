import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day1task/views/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Divider(thickness: 1.5, color: Colors.grey[700]),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          user?.displayName ?? 'No Name',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          user?.email ?? 'No Email',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
