import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'home_page.dart';
class PdfViewerPage extends StatelessWidget {
final File file;
const PdfViewerPage({
  super.key,required this.file,
});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF34C6E),
        centerTitle: true,
        title: Text(file.path.split('/').last,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

      ),
      body: SfPdfViewer.file(file),

    );
  }
}
