import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfreader/pages/pdf_viewer_page.dart';
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> openpdf = [];
  void openpdffile() async {
    print('openpdffile called');

    if (Platform.isAndroid) {
      print('Android version: ${Platform.version}');
      var status = await Permission.manageExternalStorage.status;
      print('manageExternalStorage status before request: $status');
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
        print('manageExternalStorage status after request: $status');
        if (!status.isGranted) {
          print('Permission denied, opening app settings');
          openAppSettings();
          return;
        }
      }
    } else {
      var status = await Permission.storage.request();
      print('storage permission status: $status');
      if (!status.isGranted) return;
    }

    print('Permissions granted, opening file picker...');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      print('File selected: ${file.path}');
      setState(() {
        openpdf.add(file);
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerPage(file: file)));
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("PDF-Reader",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body:  ListView.builder(
          itemCount: openpdf.length ,

          itemBuilder: (context,index)
      {
        final file = openpdf[index];
  return ListTile(
    leading: Icon(Icons.picture_as_pdf),
          title: Text(file.path.split('/').last),
    onTap: ()=>{
    Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerPage(file: file)))
    },
        );


      }),
      floatingActionButton: FloatingActionButton(onPressed: openpdffile,
        backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add,color: Colors.white       ,),
      ),
    );
  }
}
