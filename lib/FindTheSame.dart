import 'dart:math';
import 'package:abc2/GameObject.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'Tts.dart';
import 'package:abc2/GameObjectFactory.dart';
import 'size_config.dart';
import 'package:video_player/video_player.dart';
import 'CustomVideoPlayer.dart';
//import 'package:shimmer/shimmer.dart';
import 'virtual_keyboard.dart';

List<GameObject> localGameList = GameObjectFactory.buildAnimalsList();

enum MatchWith { emoji, letters }

List<GameObject> targetObject;
GameObject prevObject;
List<GameObject> choices;
AudioCache plyr = AudioCache();

class FindTheSame extends StatefulWidget {
  @override
  FindTheSameState createState() => FindTheSameState();
}

List<GameObject> getTargetGameObjectList(int size, int randomSeed) {
  List<GameObject> targetList = new List();
  var random = new Random();

  for (int i = 0; i < size; ++i) {
    if (prevObject == null) {
      targetList.add(localGameList[random.nextInt(randomSeed)]);
    } else {
      GameObject tempObject;
      while (true) {
        tempObject = localGameList[random.nextInt(randomSeed)];
        if (!identical(prevObject.name, tempObject.name)) {
          print(prevObject.name + " |Kommande: " + tempObject.name);
          targetList.add(tempObject);
          break;
        }
      }
    }
  }
  prevObject = targetList[0];
  return targetList;
}

List<GameObject> getRandomGameObjectsList(int size, int randomSeed) {
  List<GameObject> choices = new List();
  if (size > randomSeed) size = randomSeed;
  choices.addAll(targetObject);
  GameObject seedObject;

  var random = new Random();
  while ((choices.length) < size) {
    seedObject = localGameList[random.nextInt(randomSeed)];
    bool match = false;
    for (int i = 0; i < choices.length; i++) {
      if (identical(choices[i], seedObject)) {
        match = true;
      }
    }
    if (!match) {
      choices.add(seedObject);
    }
  }

  return choices..shuffle(Random(choices[0].hashCode));
}

class FindTheSameState extends State<FindTheSame> {
  CustomVideoPlayer _controller;
  int numberOfTargets = 1;
  int numberOfChoices = localGameList.length;
  int numberObjectsOnRow = 0;
  bool showVideo = false;
  double startPos = -3.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;

  String text = '';

// True if shift enabled.
  bool shiftEnabled = false;

// is true will show the numeric keyboard.
  bool isNumericMode = false;

  /// Map to keep track of score
  // final Map<String, bool> score = {};
  final double fontSizeOfTarget = 200;
  GameObjectFactory gf = GameObjectFactory();

  FindTheSameState();

  @override
  void initState() {
    //Tts.speak("Hitta lika!");
    generateTargetAndCoices();
    super.initState();
    _controller = new CustomVideoPlayer(targetObject[0].videoName);
// This listener should be in a function
    _controller.eventStream.listen((onData) {
      switch ((onData).event) {
        case Event.Play:
          // TODO: Handle this case.
          break;
        case Event.Pause:
          setState(() {
            // Changing pause icon to play icon
          });
          break;
      }
    });
  }

  Widget getVirtualKeyboard() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            text,
            // style: Theme.of(context).textTheme.display1,
          ),
          SwitchListTile(
            title: Text(
              'Keyboard Type = ' +
                  (isNumericMode
                      ? 'VirtualKeyboardType.Numeric'
                      : 'VirtualKeyboardType.Alphanumeric'),
            ),
            value: isNumericMode,
            onChanged: (val) {
              setState(() {
                isNumericMode = val;
              });
            },
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            color: Colors.white,
            child: VirtualKeyboard(
                height: SizeConfig.screenHeight * 0.3,
                textColor: Colors.black,
                type: isNumericMode
                    ? VirtualKeyboardType.Numeric
                    : VirtualKeyboardType.Alphanumeric,
                alwaysCaps: true,
                onKeyPress: _onKeyPress),
          )
        ],
      ),
    );
  }

  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (/*shiftEnabled  ? */ key.capsText /* : key.text*/);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }

  void generateTargetAndCoices() {
    localGameList = GameObjectFactory.animals;
    targetObject =
        getTargetGameObjectList(numberOfTargets, localGameList.length);
    targetObject[0].playSound();
    _controller?.getValuesAndPlay(targetObject[0].videoName);
    choices = getRandomGameObjectsList(numberOfChoices, localGameList.length);
  }

  addObject() {
    if (++numberOfChoices > localGameList.length) {
      return;
      // numberOfChoices = localGameList.length;
    }
    setState(() {
      generateTargetAndCoices();
    });
  }

  removeObject() {
    if (--numberOfChoices < 1) {
      return;
    }
    setState(() {
      generateTargetAndCoices();
    });
  }

  final Map<int, bool> score = {};
  int rightChoices = 0;

  final fruitSuccessSounds = [
    'audio/mmm-1.wav',
    'audio/mmm-2.wav',
    'audio/mmm-3.wav'
  ];

  // Random seed to shuffle order of items.
  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Score: $rightChoices'),
      ),
      floatingActionButton: FloatingActionButton(
        child: (showVideo)
            ? ((_controller.controller.value.isPlaying)
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow))
            : Icon(Icons.refresh),
        onPressed: () {
          if (showVideo) {
            if (_controller.controller.value.isPlaying) {
              _controller.controller.pause();
            } else {
              if (_controller.controller.value.position ==
                  _controller.controller.value.duration) {
                _controller.controller.seekTo(Duration.zero);
              }
              _controller.controller.play();
            }
          } else {
            generateTargetAndCoices();
            score.clear();
            seed++;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        //width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LandscapeBackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          // child: Expanded(
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(children: [
                  Center(
                    child: SizedBox(
                      height: (30 * SizeConfig.blockSizeVertical),
                      width: (40 *
                          SizeConfig
                              .blockSizeVertical), //(30 * SizeConfig.blockSizeVertical),
                      child: /*getTargetObject()*/ TweenAnimationBuilder(
                        tween: Tween<Offset>(
                            begin: Offset(startPos, 0), end: Offset(endPos, 0)),
                        duration: Duration(seconds: 1),
                        curve: curve,
                        builder: (context, offset, child) {
                          return FractionalTranslation(
                            translation: offset,
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: targetObject[0].flare,
                        /*Text(
                'animated text',
                textScaleFactor: 3.0,
              ),*/
                        onEnd: () {
                          print('onEnd');
                          Future.delayed(
                            Duration(milliseconds: 300),
                            () {
                              curve = curve == Curves.elasticOut
                                  ? Curves.elasticIn
                                  : Curves.elasticOut;
                              if (startPos == -3.0) {
                                setState(() {
                                  print("RESET");
                                  startPos = -3.0;
                                  endPos = 0.0;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.fromLTRB(
                      0 /*(SizeConfig.screenWidth * 0.005)*/, 0, 0, 0),
                  child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      children: List.generate(numberOfChoices, (index) {
                        return GestureDetector(
                          onTap: () {
                            choices[index].playSound();
                            print(choices[index].name);
                            // if (choices[index].answered) return;
                            if (choices[index].name == targetObject[0].name) {
                              //choices[index].answered = true;
                              rightChoices++;
                              Tts.speak("${choices[index].spokenName}.");
                              setState(() {
                                generateTargetAndCoices();
                              });
                            } else {
                              setState(() {
                                rightChoices = 0;
                              });

                              //Tts.speak("Fel");
                            }
                          },
                          child: Container(
                            child: SizedBox(
                              height: (numberOfChoices < 5)
                                  ? (24 * SizeConfig.blockSizeVertical)
                                  : (29 *
                                      SizeConfig.blockSizeVertical /
                                      (numberOfChoices / 5)),
                              width: SizeConfig.screenWidth / 5.61,
                              child: Card(
                                elevation: 5.0,
                                color: choices[index].color,
                                child: choices[index].flare,
                              ),
                            ),
                          ),
                        );
                      })),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                IgnorePointer(
                  ignoring: false,
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        if (showVideo) {
                          showVideo = false;
                          _controller.controller?.pause();
                          _controller.controller?.seekTo(Duration.zero);
                        } else {
                          showVideo = true;
                          // Detta ska faktoriseras bort
                          if (_controller.controller.value.position ==
                              _controller.controller.value.duration) {
                            _controller.controller.seekTo(Duration.zero);
                          }
                          _controller.controller.play();
                        }
                      });
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.video_label,
                      // size: 15.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                IgnorePointer(
                  ignoring: false,
                  child: RawMaterialButton(
                    onPressed: () {
                      removeObject();
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.remove,
                      //size: 15.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                Container(
                  width: 20,
                  height: 15,
                  child: Text("$numberOfChoices"),
                ),
                IgnorePointer(
                  ignoring: false,
                  child: RawMaterialButton(
                    onPressed: () {
                      addObject();
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      // size: 15.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
              ]),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _controller.controller.value.initialized
                    ? ((showVideo)
                        ? AspectRatio(
                            aspectRatio:
                                _controller.controller.value.aspectRatio,
                            child: VideoPlayer(_controller.controller),
                          )
                        : Container())
                    : Container(),
              ),
            ),
            // getVirtualKeyboard()
          ]),
          // ),
        ),
      ),
    );
  }

  getTargetObject() {
    return targetObject[0].flare;
    /*Shimmer.fromColors(
        period: Duration(milliseconds: 500),
        baseColor: Colors.black26,
        highlightColor: Colors.red,
        child: targetObject[0].flare);*/
  }

  @override
  void dispose() {
    _controller.dispose();
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.dispose();
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji, this.fontSize}) : super(key: key);

  final String emoji;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        // height: 80,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(
              color: Colors.black,
              fontSize: (fontSize == null) ? 160 : fontSize),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ),
    );
  }
}
