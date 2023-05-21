import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/colors.dart';
import 'package:music_player/logic/controller.dart';

class DownloadUI extends StatefulWidget {
  const DownloadUI({super.key});

  @override
  State<DownloadUI> createState() => _DownloadUIState();
}

class _DownloadUIState extends State<DownloadUI> {
  var controller = Get.find<PlayerController>();
  bool isLoading = false;
  bool downloaded = false;
  double progess = 0.0;
  String pathh = '';
  String fileName = '';
  File? file;
  downloadFile(url) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FileDownloader.downloadFile(
        url: urlController.text,
        onProgress: (fileName, progress) {
          setState(() {
            progess = progress;
          });
        },
        onDownloadCompleted: (path) {
          print(path);
          pathh = path;
          fileName = path.split('/').last;
        },
      );
      file = File(pathh);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
      downloaded = true;
    });
  }

  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              const Icon(
                Icons.download_rounded,
                color: Colors.black,
                size: 100,
              ),
              const Text('Download music here : '),
              TextField(
                controller: urlController,
                decoration:
                    const InputDecoration(hintText: 'Copy your url here ...'),
              ),
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          Text('Downloading... : $progess')
                        ],
                      ),
                    )
                  : downloaded
                      ? Column(
                          children: [
                            const Text('Done'),
                            InkWell(
                                onTap: () {
                                  controller
                                      .playDownloadedSong(file!.uri.toString());
                                },
                                child: Text(
                                    'file downloaded : $fileName (click to play)'))
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                color: bgDarkColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextButton(
                                onPressed: () async {
                                  downloadFile(urlController.text.trim());
                                },
                                child: const Text(
                                  'Download now',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
