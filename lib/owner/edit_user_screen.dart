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
  TextEditingController sallaryController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  TextEditingController emailController = TextEditingController();
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
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneNumberController.text = userData['phonenumber'] ?? '';
          sallaryController.text = userData['salary'] ?? '';
          durationController.text = userData['duration'] ?? '';
        });
      } else if (widget.name == 'Dc') {
        userSnapshot = await FirebaseFirestore.instance
            .collection('DC')
            .doc(widget.userId)
            .get();
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        nameController.text = userData['name'] ?? '';
        phoneNumberController.text = userData['phonenumber'] ?? '';
        emailController.text = userData['email'] ?? '';
      } else if (widget.name == 'head') {
        userSnapshot = await FirebaseFirestore.instance
            .collection('head')
            .doc(widget.userId)
            .get();
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        nameController.text = userData['name'] ?? '';
        phoneNumberController.text = userData['phonenumber'] ?? '';
        emailController.text = userData['email'] ?? '';
      } else {
        userSnapshot = await FirebaseFirestore.instance
            .collection('owner')
            .doc(widget.userId)
            .get();
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        nameController.text = userData['name'] ?? '';
        phoneNumberController.text = userData['phonenumber'] ?? '';
        emailController.text = userData['email'] ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 11,
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            widget.name == 'Emp'
                ? TextFormField(
                    controller: sallaryController,
                    decoration: const InputDecoration(labelText: 'salary '),
                  )
                : SizedBox(),
            widget.name == 'Emp'
                ? TextFormField(
                    controller: durationController,
                    decoration: const InputDecoration(labelText: 'duration'),
                  )
                : SizedBox(),
            widget.name != 'Emp'
                ? TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  )
                : SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateUserData();
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
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

      if (widget.name == 'Emp') {
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(widget.userId)
            .update({
          'name': updatedName,
          'phonenumber': updatedPhoneNumber,
          'duration': durationController.text,
          'salary': sallaryController.text
        });
      }
      if (widget.name == 'head') {
        await FirebaseFirestore.instance
            .collection('head')
            .doc(widget.userId)
            .update({
          'name': updatedName,
          'phonenumber': updatedPhoneNumber,
          'email': emailController.text
        });
      }
      if (widget.name == 'Dc') {
        await FirebaseFirestore.instance
            .collection('DC')
            .doc(widget.userId)
            .update({
          'name': updatedName,
          'phonenumber': updatedPhoneNumber,
          'email': emailController.text
        });
      } else {
        await FirebaseFirestore.instance
            .collection('owner')
            .doc(widget.userId)
            .update({
          'name': updatedName,
          'phonenumber': updatedPhoneNumber,
          'email': emailController.text
        });
      }
      print('User Data Updated Successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
