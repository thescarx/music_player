import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/favourites.dart';
import 'package:music_player/functions.dart';
import 'package:music_player/logic/controller.dart';
import 'package:music_player/songui.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'consts/colors.dart';
import 'download.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(PlayerController());
  bool isLoading = false;
  initializeDb() async {
    setState(() {
      isLoading = true;
    });
    try {
      await controller.favDb.open();

      print('db created with success');
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
    initializeDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.sort_rounded,
                color: whiteColor,
              )),
          title: const Text("Songs",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: whiteColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => Favourites());
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Get.to(() => DownloadUI());
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: isLoading
            ? Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Fetching and initializing database')
                  ],
                ),
              )
            : FutureBuilder<List<SongModel>>(
                future: controller.audioQuery.querySongs(
                    ignoreCase: true,
                    orderType: OrderType.ASC_OR_SMALLER,
                    sortType: null,
                    uriType: UriType.EXTERNAL),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      "No songs found",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          color: whiteColor),
                    ));
                  } else {
                    print(snapshot.data);
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => SongUI(Song: snapshot.data!),
                                    transition: Transition.downToUp);
                                print(
                                    "this is the url ${snapshot.data![index].uri}");
                                controller.playSong(
                                    snapshot.data![index].uri, index,snapshot.data![index].displayNameWOExt);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                      snapshot.data![index].displayNameWOExt,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: bgDarkColor)),
                                  subtitle: Text(
                                      '${snapshot.data![index].artist}',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: bgDarkColor)),
                                  leading: QueryArtworkWidget(
                                    id: snapshot.data![index].id,
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
                                                snapshot.data![index].uri,
                                                index,snapshot.data![index].displayNameWOExt);
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
                      ),
                    );
                  }
                },
              ));
  }
}
