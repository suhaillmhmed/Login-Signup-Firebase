import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDetailsScreen extends StatefulWidget {
  final String docId;
  final String initialTitle;
  final String initialDescription;
  const EditDetailsScreen({
    required this.docId,
    required this.initialTitle,
    required this.initialDescription,
    super.key,
  });

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
  }

  void updateDetails() async {
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
    try {
      await FirebaseFirestore.instance
          .collection('lists')
          .doc(widget.docId)
          .update({
            'title': titleController.text.trim(),
            'description': descriptionController.text.trim(),
          });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Details')),
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
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: updateDetails,
                      child: Text('Update'),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
