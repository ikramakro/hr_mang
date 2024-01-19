import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class DCCvScreen extends StatefulWidget {
  const DCCvScreen({Key? key}) : super(key: key);

  @override
  _DCCvScreenState createState() => _DCCvScreenState();
}

class _DCCvScreenState extends State<DCCvScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot>? _querySnapshot;

  @override
  void initState() {
    super.initState();
    _fetchCvData();
  }

  Future<void> _fetchCvData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('CV').get();
    setState(() {
      _querySnapshot = querySnapshot.docs;
    });
  }

  List<DocumentSnapshot> _filterCvData(String searchTerm) {
    if (_querySnapshot == null) {
      return [];
    }

    return _querySnapshot!
        .where((document) =>
            document['Department']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            document['PDF'].toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Screen'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    // Reset to initial data if search is empty
                    _fetchCvData();
                  } else {
                    // Update _querySnapshot with filtered data
                    _querySnapshot = _filterCvData(value);
                  }
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search by Department or PDF',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _querySnapshot != null && _querySnapshot!.isNotEmpty
                ? ListView.builder(
                    itemCount: _querySnapshot!.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = _querySnapshot![index];
                      return ListTile(
                        title: Text(document['Department']),
                        subtitle: Text(document['PDF']),
                        onTap: () {
                          _showPdfViewer(document['PDF']);
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('No CVs found.'),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPdfViewer(String pdfUrl) async {
    String pdfName = pdfUrl.split('/').last;
    String localPath = (await getTemporaryDirectory()).path;
    String pdfPath = '$localPath/$pdfName';

    await FirebaseStorage.instance
        .refFromURL(pdfUrl)
        .writeToFile(File(pdfPath));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfPath),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen(this.pdfPath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        pageFling: true,
        onRender: (pages) {
          print("Rendered $pages pages");
        },
      ),
    );
  }
}
