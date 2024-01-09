import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future getPdfAndUpload() async {
  var rng = Random();
  String randomName = "";
  for (var i = 0; i < 20; i++) {
    randomName += rng.nextInt(100).toString();
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    String fileName = '${randomName}.pdf';
    print(fileName);
    print('${file.readAsBytesSync()}');
    await savePdf(Uint8List.fromList(file.readAsBytesSync()), fileName);
  }
}

Future<String> savePdf(Uint8List asset, String name) async {
  Reference reference = FirebaseStorage.instance.ref().child(name);
  UploadTask uploadTask = reference.putData(asset);
  TaskSnapshot taskSnapshot = await uploadTask;
  String url = await taskSnapshot.ref.getDownloadURL();
  print(url);
  documentFileUpload(url);
  return url;
}

void documentFileUpload(String str) async {
  // Use Firestore instead of Realtime Database
  CollectionReference documentsCollection =
      FirebaseFirestore.instance.collection('Documents');

  // Generate a unique document ID for each uploaded document
  String documentId = documentsCollection.doc().id;

  var data = {
    "PDF": str,
  };

  // Set the data in Firestore
  await documentsCollection.doc(documentId).set(data);
}
