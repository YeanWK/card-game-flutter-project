import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ionicbond_providers.dart';
import '../providers/setting_provider.dart';
import 'easy_screen.dart';
import 'hard_screen.dart';
import 'medium_screen.dart';

class Level extends StatefulWidget {
  const Level({
    super.key,
  });

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {
  late final soundFx = AudioPlayer();

  void playsoundFx() async {
    var settingProvider = context.read<SettingProvider>();
    soundFx.play(AssetSource("sounds/select.mp3"));

    soundFx.setVolume(settingProvider.volumnSoundFx);

    debugPrint("settingProvider${settingProvider.volumnSoundFx}");
  }

  @override
  void dispose() {
    soundFx.dispose();
    super.dispose();
    debugPrint("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IonicProvider>(builder: (context, ionicProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                    const Center(
                      child: Text(
                        'ระดับ',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFDFDFDF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            playsoundFx();
                            ionicProvider.randomIonicbondEasy();
                            ionicProvider.randomAtomEasy();
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const EasyLevel()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // ปรับความโค้งปุ่ม
                              ),
                              side: const BorderSide(
                                color: Colors.white, // สีขอบ
                                width: 2.0, // ความหนาขอบ
                              ),
                              backgroundColor:
                                  const Color(0xFF6B76BE), // Button color
                              fixedSize: const Size(120, 32)),
                          child: const Text(
                            'ง่าย',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            playsoundFx();
                            ionicProvider.randomIonicbondMedium();
                            ionicProvider.randomAtomMedium();
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const MediumLevle()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // ปรับความโค้งปุ่ม
                              ),
                              side: const BorderSide(
                                color: Colors.white, // สีขอบ
                                width: 2.0, // ความหนาขอบ
                              ),
                              backgroundColor:
                                  const Color(0xFF6B76BE), // Button color
                              fixedSize: const Size(120, 32)),
                          child: const Text(
                            'ปานกลาง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            playsoundFx();
                            ionicProvider.randomIonicbondHard();
                            ionicProvider.randomAtomHard();
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const HardLevle()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // ปรับความโค้งปุ่ม
                              ),
                              side: const BorderSide(
                                color: Colors.white, // สีขอบ
                                width: 2.0, // ความหนาขอบ
                              ),
                              backgroundColor:
                                  const Color(0xFF6B76BE), // Button color
                              fixedSize: const Size(120, 32)),
                          child: const Text(
                            'ยาก',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
