import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CVViewerScreen extends StatefulWidget {
  final String cvPath; // Path to the CV in Firebase Storage

  const CVViewerScreen({super.key, required this.cvPath});

  @override
  _CVViewerScreenState createState() => _CVViewerScreenState();
}

class _CVViewerScreenState extends State<CVViewerScreen> {
  String? pdfUrl; // This will hold the URL of the PDF file

  @override
  void initState() {
    super.initState();
    //  _loadPdfUrl();
  }

  // Future<void> _loadPdfUrl() async {
  //   try {
  //     String url = await getPdfUrl(widget.cvPath);
  //     setState(() {
  //       pdfUrl = url;
  //     });
  //   } catch (e) {
  //     // Handle any errors
  //     print('Error getting PDF URL: $e');
  //   }
  // }

  // Future<String> getPdfUrl(String cvPath) async {
  //   final storageRef = FirebaseStorage.instance.ref().child(cvPath);
  //   String url = await storageRef.getDownloadURL();
  //   return url;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CV Viewer"),
      ),
      body: widget.cvPath != null
          ? SfPdfViewer.network(widget.cvPath)
          : const Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while URL is being fetched
    );
  }
}
