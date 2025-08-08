import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:modular_yoga_session_app/controllers/assets_controller.dart';
import 'package:modular_yoga_session_app/controllers/json_file_controller.dart';
import 'package:modular_yoga_session_app/controllers/script_audio_controller.dart';
import 'package:modular_yoga_session_app/controllers/sequence_audio_controller.dart';

class DisplayPage extends StatelessWidget {
  final String jsonUrl;
  const DisplayPage({super.key, required this.jsonUrl});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double d = sqrt(w * w + h * h);
    JsonFileController jsonFileController = Get.put(
      JsonFileController(jsonUrl),
    );
    var jsonModel = jsonFileController.jsonModel;
    AssetsController assetsController = Get.put(AssetsController(jsonModel));
    var assetsModel = assetsController.assetsModel;
    return Obx(() {
      if (jsonModel.value == null ||
          assetsModel.value == null ||
          jsonFileController.isLoading.value ||
          assetsController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      // CHANGE: Wait until currentScriptController is not null and audioPlayer is initialized
      SequenceAudioController sequenceAudioController = Get.put(
        SequenceAudioController(
          defaultLoop: jsonModel.value!.metadata!.defaultLoopCount!,
          // defaultLoop: 3,
          audios: assetsModel.value!.audio!,
          sequences: jsonModel.value!.sequence!,
          images: assetsModel.value!.images!,
        ),
      );

      // Check if currentScriptController is null or its audioPlayer is null (not yet ready)
      if (sequenceAudioController.currentScriptController.value == null ||
          !sequenceAudioController
              .currentScriptController
              .value!
              .isReady
              .value) {
        return Center(child: CircularProgressIndicator());
      }

      // Now safe to use
      var scriptAudioController =
          sequenceAudioController.currentScriptController.value!;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          leadingWidth: 40,
          leading: IconButton(onPressed: () async {
            await scriptAudioController.pause();
            scriptAudioController.dispose();
            sequenceAudioController.dispose();
            Get.back();
          }, icon: Icon(Icons.arrow_back)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    AssetsClass.asanTileImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jsonModel.value!.metadata!.title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    jsonModel.value!.metadata!.category!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: d / 60),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: d / 2.5,
                    width: d / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        scriptAudioController.currentImage.value,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  // Play / Pause Button
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        scriptAudioController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        print(scriptAudioController.isPlaying.value);
                        if (scriptAudioController.isPlaying.value) {
                          print('pause is pressed');
                          await scriptAudioController.pause();
                        } else {
                          print('resume is pressed');
                          await scriptAudioController.resume();
                        }
                        print(scriptAudioController.isPlaying.value);
                      },
                    ),
                  ),

                  // Slider
                  Obx(
                    () => SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8.0, // thicker track
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 12.0,
                        ), // bigger thumb
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20.0,
                        ), // bigger overlay on tap
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        inactiveTrackColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        thumbColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Slider(
                        value: scriptAudioController
                            .currentPosition
                            .value
                            .inSeconds
                            .toDouble(),
                        min: 0,
                        max:
                            scriptAudioController.totalDuration.value.inSeconds
                                    .toDouble() >
                                0
                            ? scriptAudioController
                                  .totalDuration
                                  .value
                                  .inSeconds
                                  .toDouble()
                            : 1, // avoid divide by zero
                        onChanged: (value) async {
                          await scriptAudioController.pause();
                          await scriptAudioController.seek(
                            Duration(seconds: value.toInt()),
                          );
                        },
                      ),
                    ),
                  ),

                  // Time labels
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(
                              scriptAudioController.currentPosition.value,
                            ),
                          ),
                          Text(
                            _formatDuration(
                              scriptAudioController.totalDuration.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
