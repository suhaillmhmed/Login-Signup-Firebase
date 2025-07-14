import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_details_screen.dart';
import '../Styles/time_stamps.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text('Home'),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDetailsScreen()),
          );
        },
        child: Text('Add +'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('lists')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No details added yet.'));
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    title: Text(
                      data['title'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['description'] ?? ''),
                        SizedBox(height: 4),
                        if (data['timestamp'] != null)
                          Text(
                            formatTimestamp(data['timestamp']),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditDetailsScreen(
                                      docId: docId,
                                      initialTitle: data['title'] ?? '',
                                      initialDescription:
                                          data['description'] ?? '',
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text('Delete'),
                                    content: Text(
                                      'Are you sure you want to delete this?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('lists')
                                  .doc(docId)
                                  .delete();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
