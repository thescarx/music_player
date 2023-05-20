import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/favsongui.dart';
import 'package:music_player/logic/controller.dart';
import 'package:music_player/songui.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'consts/colors.dart';
import 'logic/db.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  var controller = Get.find<PlayerController>();
  List<Song> favsongs = [];
  bool isLoading = false;
  findFavs() async {
    setState(() {
      isLoading = true;
    });

    try {
      favsongs = await controller.favDb.getFavorites();
      print(favsongs.length);
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findFavs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          // leading: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.sort_rounded,
          //       color: whiteColor,
          //     )),
          title: const Text("Favourite songs",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: whiteColor,
                  fontWeight: FontWeight.bold)),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: favsongs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 2),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => FavSongUI(songs: favsongs),
                              transition: Transition.downToUp);
                          print("this is the url ${favsongs[index].uri}");
                          controller.playSong(favsongs[index].uri, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(favsongs[index].name,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: bgDarkColor)),
                            subtitle: Text('${favsongs[index].artist}',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: bgDarkColor)),
                            leading: QueryArtworkWidget(
                              id: favsongs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.music_note_outlined,
                                    size: 26,
                                    color: bgDarkColor,
                                  )),
                            ),
                            trailing:
                                //  controller.playerIndex.value == index &&
                                //         controller.isPlaying.value
                                //     ?
                                // IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         controller.isPlaying(false);
                                //       });

                                //       print('pause');
                                //       controller
                                //           .pauseSong(snapshot.data![index].uri);
                                //     },
                                //     icon: const Icon(
                                //       Icons.pause,
                                //       color: bgDarkColor,
                                //       size: 26,
                                //     ))
                                // :
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.isPlaying(true);
                                      });
                                      print('play');
                                      controller.playSong(
                                          favsongs[index].uri, index);
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: bgDarkColor,
                                      size: 26,
                                    )),
                          ),
                        ),
                      ),
                    );
                  },
                )));
  }
}
