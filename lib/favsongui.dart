import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/logic/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'logic/db.dart';

class FavSongUI extends StatefulWidget {
  List<Song> songs;
   FavSongUI({super.key,required this.songs});

  @override
  State<FavSongUI> createState() => _FavSongUIState();
}

class _FavSongUIState extends State<FavSongUI> {
  var controller = Get.find<PlayerController>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    int max = widget.songs.length;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Column(
            children: [
              Obx(
                () => Expanded(
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        alignment: Alignment.center,
                        child: ClipRRect(
                          child: QueryArtworkWidget(
                            id: widget.songs[controller.playerIndex.value].id,
                            type: ArtworkType.AUDIO,
                            artworkHeight: double.infinity,
                            artworkWidth: double.infinity,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 50,
                            ),
                          ),
                        ))),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Column(
                  children: [
                    Text(
                      widget
                          .songs[controller.playerIndex.value].name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Artist : ${widget.songs[controller.playerIndex.value].artist!}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            controller.position.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Slider(
                              value: controller.value.value,
                              min: const Duration(seconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: controller.max.value,
                              onChanged: (newValue) {
                                controller
                                    .changeDurationToSeconds(newValue.toInt());
                                newValue = newValue;
                              }),
                          Text(
                            controller.duration.value,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              

                            
                                controller.playSong(
                                    widget.songs[controller.playerIndex.value - 1]
                                        .uri,
                                    controller.playerIndex.value - 1);
                                    
                              
                              
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 28,
                            )),
                        Obx(
                          () => IconButton(
                              onPressed: () {
                                if (controller.isPlaying.value) {
                                  controller.audioPlayer.pause();
                                  controller.isPlaying(false);
                                } else {
                                  controller.audioPlayer.play();
                                  controller.isPlaying(true);
                                }
                              },
                              icon: controller.isPlaying.value
                                  ? const Icon(Icons.pause,
                                      color: Colors.white, size: 28)
                                  : const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 28)),
                        ),
                        IconButton(
                            onPressed: () {
                              
                                 controller.playSong(
                                    widget.songs[controller.playerIndex.value + 1]
                                        .uri,
                                    controller.playerIndex.value + 1);
                                    
                             
                            },
                            icon: const Icon(Icons.skip_next_rounded,
                                color: Colors.white, size: 28)),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}