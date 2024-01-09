import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/owner/edit_user_screen.dart';

class CustomUser {
  final String userId;
  final String name;
  final String phoneNumber;

  CustomUser({
    required this.userId,
    required this.name,
    required this.phoneNumber,
  });
}

class OwnerHomeScreen extends StatefulWidget {
  @override
  _OwnerHomeScreenState createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  List<CustomUser> employees = [];
  List<CustomUser> heads = [];
  CustomUser? owner;
  late Future<void> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      String uid = getCurrentUserUid();
      QuerySnapshot<Map<String, dynamic>> employeesSnapshot =
          await FirebaseFirestore.instance.collection('employees').get();
      List<CustomUser> loadedEmployees = employeesSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CustomUser(
          userId: doc.id,
          name: data['name'] ?? '',
          phoneNumber: data['phonenumber'] ?? '',
        );
      }).toList();
      QuerySnapshot<Map<String, dynamic>> headsSnapshot =
          await FirebaseFirestore.instance.collection('head').get();
      List<CustomUser> loadedHeads = headsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CustomUser(
          userId: doc.id,
          name: data['name'] ?? '',
          phoneNumber: data['phonenumber'] ?? '',
        );
      }).toList();
      DocumentSnapshot<Map<String, dynamic>> ownerSnapshot =
          await FirebaseFirestore.instance.collection('owner').doc(uid).get();
      Map<String, dynamic> ownerData = ownerSnapshot.data() ?? {};
      owner = CustomUser(
        userId: uid,
        name: ownerData['name'] ?? '',
        phoneNumber: ownerData['phonenumber'] ?? '',
      );
      setState(() {
        employees = loadedEmployees;
        heads = loadedHeads;
      });
      if (employees.isEmpty && heads.isEmpty && owner == null) {
      } else {}
    } catch (e) {
      throw e;
    }
  }

  Future<void> _refreshData() async {
    await loadUserData();
  }

  String getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Home Screen'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  signOut(context);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserList('Employees', employees),
                  _buildHeadList('Heads', heads),
                  _buildOwner(owner),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadList(String title, List<CustomUser> userList) {
    return Expanded(
      child: userList.isEmpty
          ? Center(
              child: Text('No $title found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userList[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUserScreen(
                                        userId: user.userId, name: 'head'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                _removeUser(user);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserList(String title, List<CustomUser> userList) {
    return Expanded(
      child: userList.isEmpty
          ? Center(
              child: Text('No $title found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userList[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUserScreen(
                                        userId: user.userId, name: 'Emp'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                _removeUser(user);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _removeUser(CustomUser user) async {
    try {
      String collection;
      if (employees.any((e) => e.userId == user.userId)) {
        collection = 'employees';
      } else if (heads.any((h) => h.userId == user.userId)) {
        collection = 'head';
      } else {
        return;
      }
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.userId)
          .delete();
      await _refreshData();
    } catch (e) {
      print('Error removing user: $e');
    }
  }

  Widget _buildOwner(CustomUser? owner) {
    return Expanded(
      child: owner == null
          ? Center(
              child: Text('No owner found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text(owner.name),
                  subtitle: Text(owner.phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(
                              userId: owner.userId, name: 'Owner'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
