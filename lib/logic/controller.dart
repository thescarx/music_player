import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'db.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

    

  var playerIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var isFav = false.obs;

  switchFav() {
    if (isFav.value) {
      isFav(false);
    } else {
      isFav(true);
    }
  }

  Song? songToBeFavourite;
  FavoritesDatabase favDb = FavoritesDatabase();

  updatePosition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split('.')[0];
      max.value = event!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split(".")[0];
      value.value = event.inSeconds.toDouble();
    });
  }

  // pauseSong(String? uri){
  //   try {
  //     audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
  //     audioPlayer.pause();
  //     isPlaying(false);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong(String? uri, index) {
    playerIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e.toString());
    }
  }

  playDownloadedSong(url){
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url!)));
    audioPlayer.play();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermission();
  }

  checkPermission() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
    } else {
      checkPermission();
    }
  }
}
