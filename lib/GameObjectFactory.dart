import 'package:flutter/material.dart';

import 'GameObject.dart';

///
///
/// This objects will be on a DB later on..
///
///
class GameObjectFactory {
  static buildAnimalsList() {
    return [
      GameObject(
          name: ["Camel", "Kamel"],
          spokenName: ["a Camel", "en Kamel"],
          soundFilename: "",
          nameOnFlareFile: "Camel",
          videoName: ["", ""],
          colorInfo: GameObjectColor(
              colorStr: ["Yellow", "Gul"], color: Colors.yellow)),
      GameObject(
          name: ["Lion", "Lejon"],
          spokenName: ["a Lion", "ett Lejon"],
          soundFilename: "",
          nameOnFlareFile: "Lion",
          videoName: ["", "Lejon"],
          colorInfo: GameObjectColor(
              colorStr: ["Yellow", "Gul"], color: Colors.orange[400])),
      GameObject(
          name: ["Bear", "Björn"],
          spokenName: ["a Bear", "en Björn"],
          soundFilename: "",
          nameOnFlareFile: "Bear",
          videoName: ["", "Bjorn"],
          colorInfo: GameObjectColor(
              colorStr: ["Brown", "Brun"], color: Colors.brown)),
      GameObject(
          name: ["Elephant", "Elefant"],
          spokenName: ["an Elephant", "en Elefant"],
          soundFilename: "",
          nameOnFlareFile: "Elephant",
          videoName: ["", "Elefant"],
          colorInfo:
              GameObjectColor(colorStr: ["Grey", "Grå"], color: Colors.grey)),
      GameObject(
          name: ["Pelican", "Pelikan"],
          spokenName: ["a Pelican", "en Pelikan"],
          soundFilename: "",
          nameOnFlareFile: "Pelican",
          videoName: ["", ""],
          colorInfo:
              GameObjectColor(colorStr: ["White", "Vit"], color: Colors.white)),
      GameObject(
          name: ["Kangaroo", "Känguru"],
          spokenName: ["a Kangaroo", "en Känggru"],
          soundFilename: "",
          nameOnFlareFile: "AngryKangaroo",
          videoName: ["", ""],
          colorInfo: GameObjectColor(
              colorStr: ["Brown", "Brun"], color: Colors.brown)),
      GameObject(
          name: ["Butterfly", "Fjäril"],
          spokenName: ["a Butterfly", "en Fjäril"],
          soundFilename: "",
          nameOnFlareFile: "ButterFly",
          videoName: ["", ""],
          colorInfo: GameObjectColor(
              colorStr: ["Yellow", "Gul"], color: Colors.blue[600])),
      GameObject(
          name: ["Cat", "Katt"],
          spokenName: ["a Cat", "en Katt"],
          soundFilename: "",
          nameOnFlareFile: "Cat",
          videoName: ["", ""],
          colorInfo: GameObjectColor(
              colorStr: ["Grey", "Grå"], color: Colors.grey[600])),
      GameObject(
          name: ["Dog", "Hund"],
          spokenName: ["a Dog", "en Hund"],
          soundFilename: "DogBark",
          nameOnFlareFile: "Dog",
          videoName: ["", "Hund"],
          colorInfo: GameObjectColor(
              colorStr: ["Orange", "Orange"], color: Colors.orange[400])),
      GameObject(
          name: ["Snake", "Orm"],
          spokenName: ["a Snake", "en Orm"],
          soundFilename: "",
          nameOnFlareFile: "RedSnake",
          videoName: ["", "Orm"],
          colorInfo:
              GameObjectColor(colorStr: ["Red", "Röd"], color: Colors.red)),
    ];
  }

  static get animals => buildAnimalsList();
}
