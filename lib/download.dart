import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DownloadUI extends StatefulWidget {
  const DownloadUI({super.key});

  @override
  State<DownloadUI> createState() => _DownloadUIState();
}

class _DownloadUIState extends State<DownloadUI> {
  bool isLoading = false;
  bool downloaded = false;
  double progess = 0.0;
  String fileName = '';
  downloadFile(url)async{
    setState(() {
      isLoading = true;
    });
    try{
          await FileDownloader.downloadFile(url: urlController.text,
          onProgress:(fileName, progress) {
            setState(() {
              progess = progress;
            });
          },
          onDownloadCompleted:(path) {
            fileName = path;
          },);


    }catch(e){print(e.toString());}
    setState(() {
      isLoading = false;
      downloaded = true;
    });
  }
  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body:
    Center(child: Column(
      children: [
        const Text('Download music here : '),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Copy your url here ...'
          ),
        ),
        isLoading ? Column(
          children: [
            const CircularProgressIndicator(),
            Text('Downloaded : $progess')
          ],
        ):
        downloaded ? Column(children: [
          Text('Done'),
          Text('file path : $fileName')
        ],):
        TextButton(onPressed: ()async{
          downloadFile(urlController.text.trim());
        }, child: const Text('Download now'))
      ],
    ),) ,);
     
  }
}