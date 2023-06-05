// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? uid;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          'Check-in/Check-out History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employees')
            .doc(uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final DocumentSnapshot<Map<String, dynamic>>? document =
              snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;

          if (!document!.exists) {
            return const Center(
                child: Text('No check-in/check-out history available'));
          }

          final userData = document.data();
          final userName = userData!['name'];
          final checkIn = userData['checkIn'];
          final checkOut = userData['checkOut'];
          final history = userData['history'];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'User: $userName',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Check-in: ${checkIn != null ? DateFormat('yyyy-MM-dd HH:mm a').format(checkIn.toDate()) : 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Check-out: ${checkOut != null ? DateFormat('yyyy-MM-dd HH:mm a').format(checkOut.toDate()) : 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'History:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (history != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = history[index];
                    final timestamp = item['timestamp'];
                    final action = item['action'];

                    return ListTile(
                      title: Text(
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(timestamp.toDate()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(action),
                    );
                  },
                ),
              if (history == null || history.isEmpty)
                const Center(
                  child: Text('No history available'),
                ),
            ],
          );
        },
      ),
    );
  }
}
