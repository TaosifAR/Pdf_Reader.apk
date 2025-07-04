import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfreader/helper/share_files.dart';
import 'package:pdfreader/pages/pdf_viewer_page.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> openpdf = [];
  bool pressed = true;


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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PdfViewerPage(file: file)),
      );
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.more_vert),
        backgroundColor: Color(0xFFF34C6E),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "PDF-Reader",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: pressed
            ? Center(
                child: Text(
                  "Press the Plus button to open a PDF file.",
                  style: TextStyle(
                    color: Color(0xFFF34C6E),
                    fontWeight: FontWeight.bold,
                    fontSize: device.width * .045,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: openpdf.length,

                itemBuilder: (context, index) {
                  final file = openpdf[index];
                  return Card(
                    child: ListTile(
                      selectedColor: Colors.grey,
                      leading: Image.asset(
                        "asset/logo.png",
                        height: 24,
                        width: 24,
                      ),
                      title: Text(file.path.split('/').last),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfViewerPage(file: file),
                          ),
                        ),
                      },
                      trailing: InkWell(
                        onTap: () {
                          Sharepdf.sharepdf(file.path);
                        },
                        child: Icon(Icons.share),
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFF34C6E),
        onPressed: () {
          openpdffile();
          setState(() {
            pressed = false;
          });
        },
      ),
    );
  }
}
