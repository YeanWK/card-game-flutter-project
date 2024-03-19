import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ionicbond_providers.dart';
import '../providers/setting_provider.dart';
import 'level_screen.dart';
import 'search_screen.dart';
import 'setting_screen.dart';
import 'tutorial_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDataLoaded = false;
  late final soundFx = AudioPlayer();

  void playsoundFx(double volumn) async {
    soundFx.play(AssetSource("sounds/select.mp3"));
    soundFx.setVolume(volumn);
  }

  @override
  void dispose() {
    soundFx.dispose();
    super.dispose();
    debugPrint("dispose");
  }

  @override
  Widget build(BuildContext context) {
    //โหลดข้อมูลIonicbond จาก Provider
    if (!_isDataLoaded) {
      final provider = Provider.of<IonicProvider>(context, listen: false);
      provider.fetchIonicbondData();
      provider.fetchAtomData();
      provider.fetchAtomIonData();
      provider.fetchContainData();
      _isDataLoaded = true; // ทำเครื่องหมายว่าข้อมูลถูกโหลดไปแล้ว
    }
    //โหลดข้อมูลSetting เสียง จาก Provider
    final ionicbondprovider =
        Provider.of<IonicProvider>(context, listen: false);
    var settingProvider = context.read<SettingProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                playsoundFx(settingProvider.volumnSoundFx);
                await Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const Level()),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // ปรับความโค้งปุ่ม
                  ),
                  side: const BorderSide(
                    color: Colors.white, // สีขอบ
                    width: 2.0, // ความหนาขอบ
                  ),
                  backgroundColor: const Color(0xFF6B76BE), // Button color
                  fixedSize: const Size(120, 42)),
              child: const Text(
                'เริ่มเล่น',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xFF6B76BE),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        playsoundFx(
                            settingProvider.volumnSoundFx); //เล่นเสียงปุ่ม
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SearchScreen(
                                    ionicbondList:
                                        ionicbondprovider.ionicbondList,
                                  )),
                        );
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xFF6B76BE),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        playsoundFx(settingProvider.volumnSoundFx);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Tutorial(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.question_mark),
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xFF6B76BE),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        playsoundFx(settingProvider.volumnSoundFx);
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const Setting(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
