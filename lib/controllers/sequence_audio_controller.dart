import 'package:get/get.dart';
import 'package:modular_yoga_session_app/controllers/script_audio_controller.dart';
import 'package:modular_yoga_session_app/models/segment_model.dart';

class SequenceAudioController extends GetxController {
  final List<SegmentModel> sequences; // Your parsed JSON list of sequences
  final Map<String, String> images; // images map from assets
  final Map<String, String> audios;
  final int defaultLoop;

  var currentSequenceIndex = 0.obs;
  // ScriptAudioController? currentScriptController;
  Rx<ScriptAudioController?> currentScriptController =
      Rx<ScriptAudioController?>(null);

  SequenceAudioController({
    required this.defaultLoop,
    required this.audios,
    required this.sequences,
    required this.images,
  });

  @override
  void onInit() {
    super.onInit();
    if (sequences.isNotEmpty) {
      // for (int i = 0; i < defaultLoop; i++) {
      //   _loadSequence(currentSequenceIndex.value);
      // }
      _loadSequence(currentSequenceIndex.value);
    }
  }

  void _loadSequence(int index) async {
    if (currentScriptController.value != null) {
      currentScriptController.value!.dispose();
    }

    if (index < sequences.length) {
      final seq = sequences[index];

      var newController = ScriptAudioController(
        audioDuration: seq.durationSec!,
        scripts: seq.scripts!,
        audioUrl: audios[seq.audioRef]!,
        images: images,
      );

      await newController.init();

      currentScriptController.value = newController;

      // Listen to isCompleted of current ScriptAudioController
      ever(currentScriptController.value!.isCompleted, (completed) {
        if (completed == true) {
          // Move to next sequence
          int nextIndex = currentSequenceIndex.value + 1;
          if (nextIndex < sequences.length) {
            currentSequenceIndex.value = nextIndex;
            _loadSequence(nextIndex);
          } else {
            // All sequences completed
            print("All sequences completed");
          }
        }
      });
    }
  }

  @override
  void onClose() {
    currentScriptController.value?.dispose();
    super.onClose();
  }
}
