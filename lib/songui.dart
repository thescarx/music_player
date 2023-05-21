import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/colors.dart';
import 'package:music_player/logic/controller.dart';
import 'package:music_player/logic/db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongUI extends StatefulWidget {
  final List<SongModel> Song;
  const SongUI({super.key, required this.Song});

  @override
  State<SongUI> createState() => _SongUIState();
}

class _SongUIState extends State<SongUI> {
  var controller = Get.find<PlayerController>();
  searchIfFav(int id)async{
    controller.isFav.value = await controller.favDb.isElementExists(id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchIfFav(widget.Song[controller.playerIndex.value].id);
  }
  @override
  Widget build(BuildContext context) {
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
                              id: widget.Song[controller.playerIndex.value].id,
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
                        widget.Song[controller.playerIndex.value]
                            .displayNameWOExt,
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
                        "Artist : ${widget.Song[controller.playerIndex.value].artist!}",
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
                                  controller.changeDurationToSeconds(
                                      newValue.toInt());
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
                                    widget
                                        .Song[controller.playerIndex.value].uri,
                                    controller.playerIndex.value - 1,widget
                                    .Song[controller.playerIndex.value]
                                    .title);
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
                                    widget
                                        .Song[controller.playerIndex.value].uri,
                                    controller.playerIndex.value + 1,widget
                                    .Song[controller.playerIndex.value]
                                    .title);
                              },
                              icon: const Icon(Icons.skip_next_rounded,
                                  color: Colors.white, size: 28)),
                          Obx(
                            () => IconButton(
                                onPressed: () async {
                                  controller.switchFav();
                                  if (controller.isFav.value) {
                                    Song song = Song(
                                        title: widget
                                            .Song[controller.playerIndex.value]
                                            .title,
                                        name: widget
                                            .Song[controller.playerIndex.value]
                                            .displayNameWOExt,
                                        artist: widget
                                            .Song[controller.playerIndex.value]
                                            .artist!,
                                        id: widget
                                            .Song[controller.playerIndex.value]
                                            .id,
                                        uri: widget
                                            .Song[controller.playerIndex.value]
                                            .uri!);
                                    await controller.favDb.addFavorite(song);
                                    Fluttertoast.showToast(
                                        msg: 'Added to favourite');
                                    print(song.artist);
                                    print(song.title);
                                    print(song.name);
                                    print(song.id);
                                    print(song.uri);
                                  } else {
                                    await controller.favDb.removeFavorite(widget
                                        .Song[controller.playerIndex.value].id);
                                    Fluttertoast.showToast(
                                        msg: 'Removed from favourite');
                                  }
                                },
                                icon: controller.isFav.value
                                    ? Icon(
                                        Icons.favorite,
                                        size: 28,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border_outlined,
                                        size: 28,
                                      )),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        )
        );
  }
}
