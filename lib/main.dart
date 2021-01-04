//import 'dart:ffi';

import 'package:abc2/FindTheSame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'Tts.dart';
import 'svgs.dart';
import 'FindTheSame.dart';
import 'size_config.dart';

void main() => runApp(MyApp());
//void main() => runApp(MyHomePage());

class MyApp extends StatelessWidget {
  MyApp() {
    Tts();
    SVGs();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: ABC123(),
        // home: FindTheMatchingFruit(),
        debugShowCheckedModeBanner: false);
  }
}

Padding modeButton(context, StatefulWidget game, String s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(s, style: TextStyle(fontSize: 25, color: Colors.white)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => game),
        );
      },
    ),
  );
}

Padding menuButton(context, String s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(s, style: TextStyle(fontSize: 25, color: Colors.white)),
        onPressed: () {
          if (isBackgroundMusicPlaying) {
            advancedPlayer?.pause();
            isBackgroundMusicPlaying = false;
          } else {
            advancedPlayer?.resume();
            isBackgroundMusicPlaying = true;
          }
        }),
  );
}

class ABC123 extends StatelessWidget {
  ABC123() {
    initMusic();

    //plyr.play('audio/backgorundMusic.mp3');
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StartScreenBackground.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //modeButton(context, FindTheMatchingFruit(MatchWith.emoji),
              //    'Match emojis'),
              //modeButton(context, FindTheMatchingFruit(MatchWith.letters),
              //'Match letters'),
              modeButton(context, FindTheSame(), 'Find A Like'),
              //menuButton(context, "Toggle Music"),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                clipBehavior: Clip.none,
                height: 250,
                width: 250,
                child: FlareActor(
                  "assets/animations/Robbo.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.fitWidth,
                  animation: "Wave",
                  color: null,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

initMusic() async {
  //AudioPlayer.logEnabled = true;
  advancedPlayer.release();
  advancedPlayer.stop();
  plyr.clearCache();

  //plyr.clear('audio/backgorundMusic.mp3');
  if (isBackgroundMusicPlaying) return;
  //eadvancedPlayer = await plyr.loop('audio/backgorundMusic.mp3', volume: 0.1);
  isBackgroundMusicPlaying = true;
  Tts.speak("");
}

bool isBackgroundMusicPlaying = false;
AudioPlayer advancedPlayer = AudioPlayer();
AudioCache plyr = AudioCache(fixedPlayer: advancedPlayer);
