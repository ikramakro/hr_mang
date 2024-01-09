import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  final String name;

  EditUserScreen({required this.userId, required this.name});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot;
    try {
      if (widget.name == 'Emp') {
        userSnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .doc(widget.userId)
            .get();
      } else if (widget.name == 'head') {
        userSnapshot = await FirebaseFirestore.instance
            .collection('head')
            .doc(widget.userId)
            .get();
      } else {
        userSnapshot = await FirebaseFirestore.instance
            .collection('owner')
            .doc(widget.userId)
            .get();
      }

      Map<String, dynamic> userData = userSnapshot.data() ?? {};

      setState(() {
        nameController.text = userData['name'] ?? '';
        phoneNumberController.text = userData['phonenumber'] ?? '';
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateUserData();
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserData() async {
    try {
      String updatedName = nameController.text;
      String updatedPhoneNumber = phoneNumberController.text;

      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.userId)
          .update({
        'name': updatedName,
        'phonenumber': updatedPhoneNumber,
      });

      print('User Data Updated Successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
