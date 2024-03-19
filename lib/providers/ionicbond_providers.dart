import 'dart:math';
import 'package:flutter/material.dart';
import '../services/dbhelper.dart';

class IonicProvider extends ChangeNotifier {
  List<Map<String, dynamic>> ionicbondList = [];
  List<Map<String, dynamic>> ionicbondEasy = [];
  List<Map<String, dynamic>> ionicbondMedium = [];
  List<Map<String, dynamic>> ionicbondHard = [];

  Future<void> fetchIonicbondData() async {
    debugPrint("fetchIonicbondData");

    // ตรวจสอบว่ามีข้อมูลอยู่แล้วหรือไม่
    if (ionicbondList.isNotEmpty) {
      // หากมีข้อมูลอยู่แล้วไม่ต้องดึงข้อมูลใหม่
      ionicbondEasy = ionicbondList
          .where((ionicbond) => ionicbond["bond_type"] == 2)
          .toList();
      ionicbondMedium = ionicbondList
          .where((ionicbond) => ionicbond["bond_type"] == 3)
          .toList();
      ionicbondHard = ionicbondList
          .where((ionicbond) => ionicbond["bond_type"] == 4)
          .toList();
      return;
    }

    var dbHelper = DBHelper();
    ionicbondList = await dbHelper.getIonicbond();
    debugPrint("ionicbondList: $ionicbondList");
    ionicbondEasy = ionicbondList
        .where((ionicbond) => ionicbond["bond_type"] == 2)
        .toList();
    debugPrint("IonicbondEasy: $ionicbondEasy");
    ionicbondMedium = ionicbondList
        .where((ionicbond) => ionicbond["bond_type"] == 3)
        .toList();
    debugPrint("ionicbondMedium: $ionicbondMedium");
    ionicbondHard = ionicbondList
        .where((ionicbond) => ionicbond["bond_type"] == 4)
        .toList();
    debugPrint("ionicbondHard: $ionicbondHard");
  }

  //ดึงข้อมูลจากdatabase
  List<Map<String, dynamic>> atomList = [];
  Future<void> fetchAtomData() async {
    debugPrint("fetchAtomData");

    if (atomList.isNotEmpty) {
      return;
    }

    var dbHelper = DBHelper();
    atomList = await dbHelper.getAtom();
    debugPrint("atomList: $atomList");
  }

  List<Map<String, dynamic>> ionList = [];
  Future<void> fetchAtomIonData() async {
    debugPrint("fetchAtomIonData");

    if (ionList.isNotEmpty) {
      return;
    }
    var dbHelper = DBHelper();
    ionList = await dbHelper.getAtomIon();
    debugPrint("ionList: $ionList");
  }

  List<Map<String, dynamic>> containList = [];
  Future<void> fetchContainData() async {
    debugPrint("fetchContainData");

    if (containList.isNotEmpty) {
      return;
    }
    var dbHelper = DBHelper();
    containList = await dbHelper.getContain();
    debugPrint("containList: $containList");
  }

  //Split คำถาม เพื่อแบ่งอะตอม
  List<String> splitFormula(String nameFormula) {
    List<String> quizz = [];
    for (var i = 0; i < nameFormula.length; i++) {
      var symbol = "";
      var char = nameFormula[i];
      if ((!RegExp(r'[0-9]').hasMatch(char))) {
        if (char == "(" || char == ")") {
          quizz.add(char);
        } else if (char == char.toUpperCase()) {
          var nextChar = i + 1 < nameFormula.length ? nameFormula[i + 1] : null;
          if (nextChar != null && RegExp(r'[a-z]').hasMatch(nextChar)) {
            symbol = char + nextChar;
            quizz.add(symbol);
            i += 1;
          } else {
            quizz.add(char);
          }
        }
      } else {
        quizz.add(char);
      }
    }

    return quizz;
  }

  //สุ่มระดับง่าย
  List<Map<String, dynamic>> ionicbondEasyRandom = [];
  List<Map<String, dynamic>> containEasyRandom = [];
  List<String> quizzEasyRandom = []; //card คำถาม
  String checkformulasEasy = "";
  String nameEasy = "";

  void randomIonicbondEasy() {
    ionicbondEasyRandom = [
      ionicbondEasy[Random().nextInt(ionicbondEasy.length)]
    ];
    checkformulasEasy = ionicbondEasyRandom[0]["ionicbond_formulas"];
    nameEasy = ionicbondEasyRandom[0]["ionicbond_name"];
    quizzEasyRandom = splitFormula(checkformulasEasy);
    debugPrint("quizzEasyRandom: $quizzEasyRandom");
    notifyListeners();
  }

  List<String> cardAtomEasy = []; //card คำตอบ
  void randomAtomEasy() {
    int randomNumber = Random().nextInt(6) + 2;
    List<String> atomSymbolEasy = atomList
        .map((item) => item["atom_symbol"] as String)
        .toList(); //list atomsymbol
    debugPrint("randomNumber: $randomNumber");
    cardAtomEasy = List<String>.from(quizzEasyRandom);
    //เช็คตัวเลขภายในcard
    int numberCount = 0;
    for (var item in cardAtomEasy) {
      if (RegExp(r'[0-9]').hasMatch(item)) {
        numberCount++;
      }
    }
    debugPrint("numberCount:$numberCount");
    //เพิ่มตัวเลขที่สุ่ม
    if (quizzEasyRandom.length > 2 && numberCount <= 2) {
      String randomNumberAsString = randomNumber.toString();
      if (!cardAtomEasy.contains(randomNumberAsString)) {
        cardAtomEasy.add(randomNumberAsString);
      } else {
        do {
          randomNumber = Random().nextInt(6) + 2;
          randomNumberAsString = randomNumber.toString();
        } while (cardAtomEasy.contains(randomNumberAsString));
        cardAtomEasy.add(randomNumberAsString);
      }
    }

    int randomCard = (quizzEasyRandom.length * 2);
    List<String> words = nameEasy.split(" ");
    String firstWord = words.first; // คำหน้าสุด
    String lastWord = words.last; // คำท้ายสุด
    List<String> atomContain = atomSymbolEasy
        .where((atom) =>
            atom.startsWith(firstWord[0]) || atom.startsWith(lastWord[0]))
        .toList(); //atomทั้งหมดที่ขึ้นต้นด้วยname
    debugPrint("atomContain$atomContain");
    if (randomCard > 8) {
      while (cardAtomEasy.length < 8) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomEasy.length < 8) {
            if (!cardAtomEasy.contains(atomContain[i])) {
              cardAtomEasy.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }

        int randomIndex = Random().nextInt(atomSymbolEasy.length);
        String randomAtom = atomSymbolEasy[randomIndex];
        debugPrint("randomIndex: $randomAtom");
        if (!cardAtomEasy.contains(randomAtom) && cardAtomEasy.length < 8) {
          cardAtomEasy.add(randomAtom);
        }
      }
    } else {
      while (cardAtomEasy.length < randomCard) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomEasy.length < randomCard) {
            if (!cardAtomEasy.contains(atomContain[i])) {
              cardAtomEasy.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }

        int randomIndex = Random().nextInt(atomSymbolEasy.length);
        String randomAtom = atomSymbolEasy[randomIndex];
        debugPrint("randomIndex: $randomAtom");
        if (!cardAtomEasy.contains(randomAtom) &&
            cardAtomEasy.length < randomCard) {
          cardAtomEasy.add(randomAtom);
        }
      }
    }
    debugPrint("cardAtomRandomEasy: $cardAtomEasy");
    cardAtomEasy.shuffle(); //สับข้อมูล
    debugPrint("shuffle: $cardAtomEasy");
    notifyListeners();
  }

  //สุ่มระดับปานกลาง
  List<Map<String, dynamic>> ionicbondMediumRandom = [];
  List<Map<String, dynamic>> containMediumRandom = [];
  List<String> quizzMediumRandom = []; //card คำถาม
  String checkformulasMedium = "";
  String nameMedium = "";

  void randomIonicbondMedium() {
    ionicbondMediumRandom = [
      ionicbondMedium[Random().nextInt(ionicbondMedium.length)]
    ];
    checkformulasMedium = ionicbondMediumRandom[0]["ionicbond_formulas"];
    nameMedium = ionicbondMediumRandom[0]["ionicbond_name"];
    quizzMediumRandom = splitFormula(checkformulasMedium);
    debugPrint("quizzMediumRandom: $quizzMediumRandom");
    notifyListeners();
  }

  List<String> cardAtomMedium = []; //card คำตอบ
  //card คำตอบระดับปานกลาง
  void randomAtomMedium() {
    int randomNumber = Random().nextInt(6) + 2;
    List<String> atomSymbolMedium =
        atomList.map((item) => item["atom_symbol"] as String).toList();
    debugPrint("randomNumber: $randomNumber");
    cardAtomMedium = List<String>.from(quizzMediumRandom);
    //เช็คตัวเลขภายในcard
    int numberCount = 0;
    for (var item in cardAtomMedium) {
      if (RegExp(r'[0-9]').hasMatch(item)) {
        numberCount++;
      }
    }
    debugPrint("numberCount:$numberCount");
    // เช็คว่ามีตัวเลขซ้ำมั้ยและตัวเลขมีน้อยกว่า2ให้เพิ่มตัวเลข
    if (quizzMediumRandom.length > 2 && numberCount <= 2) {
      String randomNumberAsString = randomNumber.toString();
      debugPrint("randomNumberAS: $randomNumberAsString");
      if (!cardAtomMedium.contains(randomNumberAsString)) {
        cardAtomMedium.add(randomNumberAsString);
      } else {
        do {
          randomNumber = Random().nextInt(6) + 2;
          randomNumberAsString = randomNumber.toString();
        } while (cardAtomMedium.contains(randomNumberAsString));
        cardAtomMedium.add(randomNumberAsString);
      }
    }

    List<String> words = nameMedium.split(" ");
    String firstWord = words.first; // คำหน้าสุด
    String lastWord = words.last; // คำท้ายสุด
    List<String> atomContain = atomSymbolMedium
        .where((atom) =>
            atom.startsWith(firstWord[0]) || atom.startsWith(lastWord[0]))
        .toList(); //atomทั้งหมดที่ขึ้นต้นด้วยname
    debugPrint("atomContain$atomContain");
    int randomCard = (quizzMediumRandom.length + 2);
    int totalCard = quizzMediumRandom.length + randomCard;
    if (totalCard > 12) {
      while (cardAtomMedium.length < 12) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomMedium.length < 12) {
            if (!cardAtomMedium.contains(atomContain[i])) {
              cardAtomMedium.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }
        int randomIndex = Random().nextInt(atomSymbolMedium.length);
        String randomAtom = atomSymbolMedium[randomIndex];
        if (!cardAtomMedium.contains(randomAtom) &&
            cardAtomMedium.length < 12) {
          cardAtomMedium.add(randomAtom);
        }
      }
    } else {
      while (cardAtomMedium.length < totalCard) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomMedium.length < totalCard) {
            if (!cardAtomMedium.contains(atomContain[i])) {
              cardAtomMedium.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }
        int randomIndex = Random().nextInt(atomSymbolMedium.length);
        String randomAtom = atomSymbolMedium[randomIndex];
        if (!cardAtomMedium.contains(randomAtom) &&
            cardAtomMedium.length < totalCard) {
          cardAtomMedium.add(randomAtom);
        }
      }
    }
    debugPrint("cardAtomMedium: $cardAtomMedium");
    cardAtomMedium.shuffle();
    debugPrint("shuffle: $cardAtomMedium");
    notifyListeners();
  }

  //สุ่มระดับยาก
  List<Map<String, dynamic>> ionicbondHardRandom = [];
  List<Map<String, dynamic>> containHardRandom = [];
  List<String> quizzHardRandom = []; //card คำถาม
  String checkformulasHard = "";
  String nameHard = "";

  void randomIonicbondHard() {
    ionicbondHardRandom = [
      ionicbondHard[Random().nextInt(ionicbondHard.length)]
    ];
    checkformulasHard = ionicbondHardRandom[0]["ionicbond_formulas"];
    nameHard = ionicbondHardRandom[0]["ionicbond_name"];
    quizzHardRandom = splitFormula(checkformulasHard);
    debugPrint("quizzHardRandom: $quizzHardRandom");
    notifyListeners();
  }

  List<String> cardAtomHard = []; //card คำตอบ
  //card คำตอบระดับยาก
  void randomAtomHard() {
    int randomNumber = Random().nextInt(6) + 2;
    List<String> atomSymbolHard =
        atomList.map((item) => item["atom_symbol"] as String).toList();
    debugPrint("randomNumber: $randomNumber");
    cardAtomHard = List<String>.from(quizzHardRandom);
    //เช็คตัวเลขภายในcard
    int numberCount = 0;
    for (var item in cardAtomHard) {
      if (RegExp(r'[0-9]').hasMatch(item)) {
        numberCount++;
      }
    }
    debugPrint("numberCount:$numberCount");
    // เช็คว่ามีตัวเลขซ้ำมั้ยและตัวเลขมีน้อยกว่า2ให้เพิ่มตัวเลข
    if (quizzHardRandom.length > 2 && numberCount <= 3) {
      String randomNumberAsString = randomNumber.toString();
      if (!cardAtomHard.contains(randomNumberAsString)) {
        cardAtomHard.add(randomNumberAsString);
      } else {
        do {
          randomNumber = Random().nextInt(6) + 2;
          randomNumberAsString = randomNumber.toString();
        } while (cardAtomHard.contains(randomNumberAsString));
        cardAtomHard.add(randomNumberAsString);
      }
    }

    List<String> words = nameHard.split(" ");
    String firstWord = words.first; // คำหน้าสุด
    String lastWord = words.last; // คำท้ายสุด
    List<String> atomContain = atomSymbolHard
        .where((atom) =>
            atom.startsWith(firstWord[0]) || atom.startsWith(lastWord[0]))
        .toList(); //atomทั้งหมดที่ขึ้นต้นด้วยname
    debugPrint("atomContain$atomContain");
    int randomCard = (quizzHardRandom.length * 2);
    if (randomCard > 16) {
      // randomCard = randomCard - (totalCard-12);
      while (cardAtomHard.length < 16) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomHard.length < 16) {
            if (!cardAtomHard.contains(atomContain[i])) {
              cardAtomHard.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }
        int randomIndex = Random().nextInt(atomSymbolHard.length);
        String randomAtom = atomSymbolHard[randomIndex];
        if (!cardAtomHard.contains(randomAtom) && cardAtomHard.length < 16) {
          cardAtomHard.add(randomAtom);
        }
      }
    } else {
      while (cardAtomHard.length < randomCard) {
        for (var i = 0; i < atomContain.length; i++) {
          if (cardAtomHard.length < randomCard) {
            if (!cardAtomHard.contains(atomContain[i])) {
              cardAtomHard.add(atomContain[i]);
              debugPrint("atomContain[$i]: ${atomContain[i]}");
            }
          } else {
            break;
          }
        }
        int randomIndex = Random().nextInt(atomSymbolHard.length);
        String randomAtom = atomSymbolHard[randomIndex];
        if (!cardAtomHard.contains(randomAtom) &&
            cardAtomHard.length < randomCard) {
          cardAtomHard.add(randomAtom);
        }
      }
    }
    debugPrint("cardAtomHard: $cardAtomHard");
    cardAtomHard.shuffle();
    debugPrint("shuffle: $cardAtomHard");
    notifyListeners();
  }
}
