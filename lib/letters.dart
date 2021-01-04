import 'dart:math';
import 'package:flutter/material.dart';
import 'Tts.dart';

class Letters extends StatefulWidget {
  @override
  _LettersState createState() => _LettersState();
}

enum TtsState { playing, stopped, paused, continued }

class _LettersState extends State<Letters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StartScreenBackground.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GridView.count(
            crossAxisCount: 9,
            children: List.generate(alphabetLength(), (i) {
              return GestureDetector(
                child: Center(
                    child: Text(alphabetLetter(i),
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.accents[
                                Random().nextInt(Colors.accents.length)]))),
                onTap: () => Tts.speak(alphabetLetter(i).toLowerCase()),
              );
            }),
          ),
        ),
      ),
    );
  }
}

int alphabetLength() => 'z'.codeUnits.first - 'a'.codeUnits.first + 1;
String alphabetLetter(index) {
  return String.fromCharCode('a'.codeUnits.first + index).toUpperCase();
}
