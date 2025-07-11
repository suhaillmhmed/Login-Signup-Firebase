import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void submitDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Please fill all fields";
        isLoading = false;
      });
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        errorMessage = "No user logged in. Please login again.";
        isLoading = false;
      });
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('lists').add({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await Future.delayed(Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            if (errorMessage != null) ...[
              SizedBox(height: 12),
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: submitDetails,
                  child: Text('Submit'),
                ),
          ],
        ),
      ),
    );
  }
}
