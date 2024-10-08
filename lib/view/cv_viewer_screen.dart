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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CV Viewer"),
      ),
      body: widget.cvPath.isNotEmpty
          ? SfPdfViewer.network(widget.cvPath)
          : const Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while URL is being fetched
    );
  }
}
