import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(uid).get();
      return snapshot.get('role') as String?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
