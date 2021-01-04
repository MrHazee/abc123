import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

enum TtsState { playing, stopped, paused, continued }

class Tts {
  static FlutterTts flutterTts = FlutterTts();
  dynamic languages;
  TtsState ttsState = TtsState.stopped;

  Tts() {
    initTts();
  }
  initTts() async {
    flutterTts = FlutterTts();

    _getLanguages();

    //flutterTts.setLanguage(language)

    await flutterTts.setLanguage("en");

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      } else if (Platform.isIOS) {
        await flutterTts
            .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ]);
      }
    }
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    //if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print('TTS engines' + engine);
      }
    }
  }

  static Future speak(String str) async {
    var result = await flutterTts.speak(str);
    result = result; // avoiding warnings
    //if (result == 1) setState(() => ttsState = TtsState.playing);
  }
}

int alphabetLength() => 'z'.codeUnits.first - 'a'.codeUnits.first + 1;
String alphabetLetter(index) {
  return String.fromCharCode('a'.codeUnits.first + index).toUpperCase();
}
