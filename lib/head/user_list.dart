import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/head/home_page.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message_rounded,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: const Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final name = user['name'];
              final email = user['email'];
              final phonenumber = user['phonenumber'];

              return ListTile(
                leading: const Image(
                  image: AssetImage(
                    'assets/images/hrbg.png',
                  ),
                ),
                title: Text(name),
                subtitle: Text(email),
                trailing: Text(phonenumber),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatefulWidget {
  final DocumentSnapshot user;

  const UserDetailScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user['name'];
    _emailController.text = widget.user['email'];
    _durationController.text = widget.user['duration'] ?? '';
    _salaryController.text = widget.user['salary'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _durationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedName = _nameController.text;
    final updatedEmail = _emailController.text;
    final updatedDuration = _durationController.text;
    final updatedSalary = _salaryController.text;

    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.user.id)
          .update({
        'name': updatedName,
        'email': updatedEmail,
        'duration': updatedDuration,
        'salary': updatedSalary,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving changes: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HeadHomeScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text('User Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration:
                  const InputDecoration(labelText: 'Duration of Employee'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _saveChanges,
                child: const Center(child: Text('Save Changes')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
