import 'dart:io';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:modular_yoga_session_app/models/script_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class ScriptAudioController extends GetxController {
  final int audioDuration;
  final List<ScriptModel> scripts;
  final String audioUrl;
  final Map<String, String> images;

  ScriptAudioController({
    required this.audioDuration,
    required this.scripts,
    required this.audioUrl,
    required this.images,
  });

  late AudioPlayer audioPlayer;
  late List<String> imageUrls;

  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var isCompleted = false.obs;
  var currentImage = AssetsClass.asanTileImageUrl.obs;
  RxBool isReady=false.obs;

  // @override
  Future<void> init() async {
    // TODO: implement onInit
    super.onInit();
    audioPlayer = AudioPlayer();
    imageUrls = List.filled(audioDuration+100, AssetsClass.asanTileImageUrl);
    storeImageUrls();

    // totalDuration.value=Duration(seconds: audioDuration);

    // CHANGE: Instead of directly setting URL, download and compress
    // String processedPath = await _downloadAndCompressAudio(audioUrl);
    // await audioPlayer.setFilePath(processedPath);

    audioPlayer.setUrl(audioUrl);
    // await audioPlayer.setUrl(audioUrl);
  //   .then((_) async {
  //   // Wait until duration is available
  //   final d = await audioPlayer.duration;
  //   if (d != null) {
  //     await audioPlayer.setSpeed(1.5);
  //   }
  //   await play(); // Play only after speed is applied
  // });

    audioPlayer.durationStream.listen((d) async {
      // double speed=audioDuration/(d.inSeconds * 1.0);
        // print('S P E E D'+'${d}');
      if (d != null) {
        totalDuration.value = d;
      //   double speed=d.inSeconds/(audioDuration * 1.0);
        print('S P E E D '+'${d}');
      // await audioPlayer.setSpeed(speed+0.5);
    }
    });


    audioPlayer.positionStream.
    throttleTime(const Duration(seconds: 1)).
    listen((
      p,
    ) {
      if(imageUrls[p.inSeconds]!=currentImage.value){
        currentImage.value=imageUrls[p.inSeconds];
      }
      currentPosition.value = p;
    });

    audioPlayer.playerStateStream.listen((state) {
      if (isPlaying.value != state.playing) {
      isPlaying.value = state.playing;
    }
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        isCompleted.value = true;
      }
    });

    await play();
    isReady.value=true;
  }


  void storeImageUrls() {
    for (var script in scripts) {
      int start = script.startSec!;
      int end = script.endSec!;
      for (int i = start; i <= end; i++) {
        imageUrls[i] = images[script.imageRef!] ?? AssetsClass.asanTileImageUrl;
      }
    }
    print(imageUrls[0]+imageUrls[1]+imageUrls[7]);
  }

  Future<void> play() async {
    await audioPlayer.play();
    // isPlaying.value = true;
  }

  Future<void> pause() async {
    await audioPlayer.pause();
    // isPlaying.value = false;
  }

  Future<void> resume() async {
    await audioPlayer.play();
    // isPlaying.value = true;
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    await pause();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
