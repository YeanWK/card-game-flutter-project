import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/img_model.dart';
import '../providers/ionicbond_providers.dart';
import '../providers/setting_provider.dart';
import 'widgets/hidden_letter.dart';

class EasyLevel extends StatefulWidget {
  const EasyLevel({super.key});

  @override
  State<EasyLevel> createState() => _EasyLevelState();
}

class _EasyLevelState extends State<EasyLevel> with TickerProviderStateMixin {
  List<String> quizz = []; //คำถาม
  List selectAtom = []; //การ์ดอะตอมที่เลือก
  int point = 0; //คะแนนต่อข้อ
  int totalpoint = 0; //คะแนนรวมทั้งหมด
  int wrong = 0; //status จะเพิ่มเมื่อตอบผิด

  int quizzNumber = 1;
  String card = "";

  opendialog(String title) {
    var ionicbondProvider = context.read<IonicProvider>();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 160,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xFF232B38),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "คะแนนรวม",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    " $totalpoint",
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFF6B76BE),
                          border: Border.all(
                            color: Colors.white, // สีขอบ
                            width: 1, // ความกว้างของขอบ
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            playsoundFx();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);

                            setState(() {
                              wrong = 0;
                              selectAtom.clear();
                              totalpoint = 0;
                              point = 0;
                              quizzNumber = 1;
                              _isBoy = true;
                              card = "";
                            });
                          },
                          child: const Center(
                            child: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFF6B76BE),
                          border: Border.all(
                            color: Colors.white, // สีขอบ
                            width: 1, // ความกว้างของขอบ
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            playsoundFx();
                            playMusic(1);
                            Navigator.pop(context);
                            ionicbondProvider.randomIonicbondEasy();
                            ionicbondProvider.randomAtomEasy();
                            setState(() {
                              isWon = false;
                              wrong = 0;
                              selectAtom.clear();
                              totalpoint = 0;
                              point = 0;
                              quizzNumber = 1;
                              _isBoy = true;
                              card = "";
                              restartTimerBoy();
                            });
                          },
                          child: const Center(
                            child: Icon(
                              Icons.restart_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          );
        });
  }

  bool isWon = false;
  late Timer _timerWon;
  late ConfettiController _centerController;
  //ตรวจสอบการ์ด
  checkletter(String atom) {
    // debugPrint("wrong$wrong");
    // debugPrint(images[wrong]);
    var ionicbondProvider = context.read<IonicProvider>();
    if (quizz.contains(atom)) {
      playsound("sounds/correct.mp3");
      setState(() {
        // playsound("sounds/correct.mp3");
        selectAtom.add(atom);
        totalpoint += 10;
        point += 10;
        // debugPrint("selectAtom:$selectAtom");
      });
    } else if (wrong != 4) {
      // debugPrint("wrong != 5");
      restartTimerBoy();
      playsound("sounds/pop.mp3");
      setState(() {
        wrong += 1;
        debugPrint("wrong:$wrong");
        // point -= 10;
      });
      playMusic(1 + (wrong * 0.2));
    } else {
      restartTimerBoy();
      playsound("sounds/pop.mp3");
      wrong += 1;
      debugPrint("wrong:$wrong");
      // opendialog("YOU LOST!!");
      // debugPrint("YOU LOST !!");
    }
    isWon = true;
    for (var i in quizz) {
      String char = i;
      // debugPrint("var i$char");
      if (!selectAtom.contains(char)) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }

    if (isWon == true) {
      if (quizzNumber == 10) {
        playMusic(1);
        _centerController.play();
        _timerWon = Timer(const Duration(seconds: 5), () {
          _centerController.stop();
          opendialog("YOU WIN !!");
          debugPrint("YOU WIN !!");
        });
      } else {
        playMusic(1);
        _centerController.play();
        _timerWon = Timer(const Duration(seconds: 5), () {
          _centerController.stop();
          ionicbondProvider.randomIonicbondEasy();
          ionicbondProvider.randomAtomEasy();
          setState(() {
            point = 0;
            wrong = 0;
            selectAtom.clear();
            quizzNumber += 1;
            _isBoy = true;
            card = "";
            isWon = false;
          });
        });
      }
    }
  }

  late AnimationController _controllerTree;
  late AnimationController _controllerBoy;
  late AnimationController _controllerEat;
  late Animation<double> _animationTree;
  late Animation<double> _animationBoy;
  late Animation<int> _animationEat;
  bool _isBoy = true;
  late Timer _timerBoy;
  List<Widget> tree = [
    Image.asset(ImgCharacter.tree1),
    Image.asset(ImgCharacter.tree2),
    Image.asset(ImgCharacter.tree3),
    Image.asset(ImgCharacter.tree4),
  ];
  List<Widget> eat = [
    Image.asset(ImgCharacter.eat),
    Image.asset(ImgCharacter.eat0),
    Image.asset(ImgCharacter.eat1),
    Image.asset(ImgCharacter.eat2),
    Image.asset(ImgCharacter.eat3),
    Image.asset(ImgCharacter.eat4),
    Image.asset(ImgCharacter.eat5),
    Image.asset(ImgCharacter.eat6),
  ];
  void animationTree() {
    _controllerTree =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animationTree =
        CurvedAnimation(parent: _controllerTree, curve: Curves.easeInOut);
    _controllerTree.repeat(reverse: true);
  }

  //เปลี่ยนรูป
  void animationSwiftBoy() {
    _timerBoy = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _isBoy = !_isBoy;

        _timerBoy.cancel();
      });
      if (wrong == 5) {
        setState(() {
          wrong += 1;

          animationEat();
        });
      }
    });
  }

//ขยับขึ้นลง
  void animationBoy() {
    _controllerBoy =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animationBoy = Tween<double>(begin: 0, end: 3).animate(_controllerBoy);
    _controllerBoy.repeat(reverse: true);
  }

  void animationEat() {
    _controllerEat = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animationEat =
        IntTween(begin: 0, end: eat.length - 1).animate(_controllerEat)
          ..addListener(() {
            setState(() {});
          });
    _controllerEat.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _animationEat.value == eat.length - 1 &&
          wrong == 6) {
        _controllerEat.stop();
        opendialog("YOU LOST !!");
      }
    });
    _controllerEat.forward();
  }

  void restartTimerBoy() {
    _timerBoy.cancel(); // ยกเลิก _timerBoy ที่มีอยู่ก่อนหน้านี้
    animationSwiftBoy(); // เริ่ม _timerBoy ใหม่
  }

  late final playerSound = AudioPlayer();
  late final playerMusic = AudioPlayer();
  void playsound(String sound) async {
    var settingProvider = context.read<SettingProvider>();

    playerSound.play(AssetSource(sound));
    playerSound.setVolume(settingProvider.volumnMusic);
  }

  void playMusic(double rate) {
    var settingProvider = context.read<SettingProvider>();
    playerMusic.play(
      AssetSource("sounds/music.mp3"),
    );
    playerMusic.setVolume(settingProvider.volumnMusic);
    playerMusic.setPlaybackRate(rate);
    // playerMusic.onPlayerComplete.listen((event) {
    //   playerMusic.play(
    //     AssetSource("sounds/music.mp3"),
    //   );
    // });
  }

  late final soundFx = AudioPlayer();
  void playsoundFx() async {
    var settingProvider = context.read<SettingProvider>();
    soundFx.play(AssetSource("sounds/select.mp3"));
    soundFx.setVolume(settingProvider.volumnSoundFx);
  }

  @override
  void initState() {
    super.initState();
    animationTree();
    animationBoy();
    animationSwiftBoy();
    animationEat();
    _timerWon = Timer(const Duration(seconds: 5), () {});
    _centerController =
        ConfettiController(duration: const Duration(seconds: 2));
    playMusic(1);
    // playSound();
  }

  @override
  void dispose() {
    _controllerTree.dispose();
    _controllerBoy.dispose();
    _controllerEat.dispose();
    _centerController.dispose();
    _timerBoy.cancel();
    _timerWon.cancel();
    playerSound.dispose();
    playerMusic.dispose();
    soundFx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // playMusic("sounds/music.mp3");
    return Consumer<IonicProvider>(builder: (context, valueProvider, child) {
      quizz = valueProvider.quizzEasyRandom;
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xFF6B76BE),
                      ),
                      child: IconButton(
                        onPressed: () {
                          playsoundFx();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'ข้อ $quizzNumber',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    //อนิเมชั่น
                    Expanded(
                      child: Column(
                        children: [
                          buildAnimatedBoyImage(),
                          buildAnimatedDevilImage(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          //โปรยกระดาษ
                          Align(
                            alignment: Alignment.center,
                            child: ConfettiWidget(
                              confettiController: _centerController,
                              blastDirection: pi / 2,
                              maxBlastForce: 2,
                              minBlastForce: 1,
                              emissionFrequency: 0.02,
                              numberOfParticles: 2,
                              gravity: 0,
                            ),
                          ),
                          Column(
                            children: [
                              //คำถาม
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: valueProvider.quizzEasyRandom
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: hiddenLetter(
                                                    e,
                                                    !selectAtom.contains(e),
                                                    valueProvider
                                                        .quizzEasyRandom),
                                              ))
                                          .toList(),
                                    ),
                                    Text(
                                      valueProvider.nameEasy,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              //การ์ด
                              Expanded(
                                child: buildCard(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //ช่องคะแนน,เวลา
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 60,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xFF6B76BE),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "คะแนนรวม",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  totalpoint.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 60,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xFF6B76BE),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "คะแนน",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  point.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

//สร้างการ์ด Gridview
  Widget buildCard() {
    var ionicbondProvider = context.read<IonicProvider>();
    if (ionicbondProvider.cardAtomEasy.length <= 4) {
      return SizedBox(
        width: 170,
        child: GridView.count(
          padding: const EdgeInsets.only(top: 20),
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ionicbondProvider.cardAtomEasy.map((atom) {
            return InkWell(
              onTap: wrong >= 5 || isWon == true || selectAtom.contains(atom)
                  ? null
                  : () {
                      card = atom;
                      checkletter(atom);
                      // debugPrint("selectAtom$selectAtom");
                      // debugPrint("card:$card");
                      // debugPrint("_isBoy:$_isBoy");
                      // debugPrint("selectAtom == quizz:$selectAtom");
                      // debugPrint("quizz:$quizz");
                    },
              child: Container(
                color: selectAtom.contains(atom)
                    ? Colors.grey
                    : const Color(0xFFF3BB5B),
                child: Center(
                  child: Text(
                    atom,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    if (ionicbondProvider.cardAtomEasy.length <= 6) {
      return SizedBox(
        width: 255,
        child: GridView.count(
          padding: const EdgeInsets.only(top: 20),
          crossAxisCount: 6,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ionicbondProvider.cardAtomEasy.map((atom) {
            return InkWell(
              onTap: wrong >= 5 || isWon == true || selectAtom.contains(atom)
                  ? null
                  : () {
                      card = atom;
                      checkletter(atom);
                      // debugPrint("selectAtom$selectAtom");
                      // debugPrint("card:$card");
                      // debugPrint("_isBoy:$_isBoy");
                      // debugPrint("selectAtom == quizz:$selectAtom");
                      // debugPrint("quizz:$quizz");
                    },
              child: Container(
                color: selectAtom.contains(atom)
                    ? Colors.grey
                    : const Color(0xFFF3BB5B),
                child: Center(
                  child: Text(
                    atom,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return SizedBox(
        width: 340,
        child: GridView.count(
          padding: const EdgeInsets.only(top: 20),
          crossAxisCount: 8,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ionicbondProvider.cardAtomEasy.map((atom) {
            return InkWell(
              onTap: wrong >= 5 || isWon == true || selectAtom.contains(atom)
                  ? null
                  : () {
                      card = atom;
                      checkletter(atom);
                      // debugPrint("selectAtom$selectAtom");
                      // debugPrint("card:$card");
                      // debugPrint("_isBoy:$_isBoy");
                    },
              child: Container(
                color: selectAtom.contains(atom)
                    ? Colors.grey
                    : const Color(0xFFF3BB5B),
                child: Center(
                  child: Text(
                    atom,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  //อนิเมชัน
  bool lost = false;
  Widget buildAnimatedBoyImage() {
    if (wrong == 0) {
      _isBoy = true;
      return AnimatedBuilder(
          animation: _animationBoy,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animationBoy.value * 2),
              child: child,
            );
          },
          child: const Image(
            height: 120,
            fit: BoxFit.cover,
            image: AssetImage(ImgCharacter.boy),
          ));
    }
    if (wrong == 1) {
      restartTimerBoy();
      if (quizz.contains(card)) {
        return AnimatedBuilder(
            animation: _animationBoy,
            builder: (context, child) {
              _isBoy = true;
              return Transform.translate(
                offset: Offset(0, _animationBoy.value * 2),
                child: child,
              );
            },
            child: const Image(
              height: 120,
              fit: BoxFit.cover,
              image: AssetImage(ImgCharacter.boy1_1),
            ));
      } else {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isBoy
              ? AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy1),
                  ))
              : AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    _isBoy = true;

                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy1_1),
                  )),
        );
      }
    }
    if (wrong == 2) {
      // restartTimerBoy();
      if (quizz.contains(card)) {
        return AnimatedBuilder(
            animation: _animationBoy,
            builder: (context, child) {
              _isBoy = true;

              return Transform.translate(
                offset: Offset(0, _animationBoy.value * 2),
                child: child,
              );
            },
            child: const Image(
              height: 120,
              fit: BoxFit.cover,
              image: AssetImage(ImgCharacter.boy2_1),
            ));
      } else {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isBoy
              ? AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy2),
                  ))
              : AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    _isBoy = true;

                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy2_1),
                  )),
        );
      }
    }
    if (wrong == 3) {
      // restartTimerBoy();
      if (quizz.contains(card)) {
        return AnimatedBuilder(
            animation: _animationBoy,
            builder: (context, child) {
              _isBoy = true;
              return Transform.translate(
                offset: Offset(0, _animationBoy.value * 2),
                child: child,
              );
            },
            child: const Image(
              height: 120,
              fit: BoxFit.cover,
              image: AssetImage(ImgCharacter.boy3_1),
            ));
      } else {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isBoy
              ? AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy3),
                  ))
              : AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    _isBoy = true;
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy3_1),
                  )),
        );
      }
    }
    if (wrong == 4) {
      // restartTimerBoy();
      if (quizz.contains(card)) {
        return AnimatedBuilder(
            animation: _animationBoy,
            builder: (context, child) {
              _isBoy = true;
              return Transform.translate(
                offset: Offset(0, _animationBoy.value * 2),
                child: child,
              );
            },
            child: const Image(
              height: 120,
              fit: BoxFit.cover,
              image: AssetImage(ImgCharacter.boy4_1),
            ));
      } else {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isBoy
              ? AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy4),
                  ))
              : AnimatedBuilder(
                  animation: _animationBoy,
                  builder: (context, child) {
                    _isBoy = true;
                    return Transform.translate(
                      offset: Offset(0, _animationBoy.value * 2),
                      child: child,
                    );
                  },
                  child: const Image(
                    height: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(ImgCharacter.boy4_1),
                  )),
        );
      }
    }
    if (wrong == 5) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isBoy
            ? AnimatedBuilder(
                animation: _animationBoy,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animationBoy.value * 2),
                    child: child,
                  );
                },
                child: const Image(
                  height: 120,
                  fit: BoxFit.cover,
                  image: AssetImage(ImgCharacter.boy5),
                ))
            : AnimatedBuilder(
                animation: _animationBoy,
                builder: (context, child) {
                  _isBoy = true;

                  return Transform.translate(
                    offset: Offset(0, _animationBoy.value * 2),
                    child: child,
                  );
                },
                child: const Image(
                  height: 120,
                  fit: BoxFit.cover,
                  image: AssetImage(ImgCharacter.boy5_1),
                )),
      );
    } else {
      return Container();
    }
  }

  Widget buildAnimatedDevilImage() {
    if (wrong == 6) {
      return eat[_animationEat.value];
    } else {
      return AnimatedBuilder(
        animation: _animationTree,
        builder: (context, child) {
          final int index =
              (_animationTree.value * tree.length).floor() % tree.length;
          return tree[index];
        },
      );
    }
  }
}
