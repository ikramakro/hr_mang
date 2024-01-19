import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? uid = '';
Future getPdfAndUpload(
    FilePickerResult? result, String dep, String username, String email) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  uid = sharedPreferences.getString('userid1');

  var rng = Random();
  String randomName = "";
  for (var i = 0; i < 20; i++) {
    randomName += rng.nextInt(100).toString();
  }

  if (result != null) {
    File file = File(result.files.single.path!);
    // ignore: unnecessary_brace_in_string_interps
    String fileName = '${randomName}.pdf';
    print(fileName);
    print('${file.readAsBytesSync()}');
    await savePdf(Uint8List.fromList(file.readAsBytesSync()), fileName, dep,
        username, email);
  }
}

Future<String> savePdf(Uint8List asset, String name, String dep,
    String username, String email) async {
  Reference reference = FirebaseStorage.instance.ref().child(name);
  UploadTask uploadTask = reference.putData(asset);
  TaskSnapshot taskSnapshot = await uploadTask;
  String url = await taskSnapshot.ref.getDownloadURL();
  print('url123 $url');
  documentFileUpload(url, dep, username, email);
  return url;
}

void documentFileUpload(
    String str, String dep, String name, String email) async {
  // Check if the email already exists in the 'CV' collection
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('CV')
      .where('Email', isEqualTo: email)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Email already exists, show a message to the user
    // You can use Fluttertoast or any other method to show the message
    // For example, if you are using Fluttertoast:
    Fluttertoast.showToast(
      msg: 'Email is already in use. Please use a different email.',
    );
  } else {
    // Email doesn't exist, add a new document to the 'CV' collection
    FirebaseFirestore.instance.collection('CV').add({
      "PDF": str,
      "Department": dep,
      "Name": name,
      "Email": email,
    });
    Fluttertoast.showToast(msg: 'Cv Uploaded Succesfully');

    // Optionally, you can show a success message here if needed
  }
}


// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write: if false;  
//     }

//     match /head/{headId}/{document=**} {
//       allow read, write: if request.auth != null;
//     }

//     match /employees/{employeeId}/{document=**} {
//       allow read, write: if request.auth != null;
//     }

//     match /owner/{ownerId}/{document=**} {
//       allow read, write: if request.auth != null;
//     }
//   }
// }



