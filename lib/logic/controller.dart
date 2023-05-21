import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
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
  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Music Notification',
      'Music is playing',
      platformChannelSpecifics,
    );
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
      _createNotification(uri);
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

  Future<void> _createNotification(uri) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Music Notification',
      uri,
      platformChannelSpecifics,
    );
  }



}

