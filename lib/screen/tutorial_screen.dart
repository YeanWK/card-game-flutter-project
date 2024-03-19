import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting_provider.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late final soundFx = AudioPlayer();

  void playsoundFx() async {
    var settingProvider = context.read<SettingProvider>();
    soundFx.play(AssetSource("sounds/select.mp3"));
    soundFx.setVolume(settingProvider.volumnSoundFx);
  }

  @override
  void dispose() {
    soundFx.dispose();
    super.dispose();
    debugPrint("dispose");
  }

  @override
  Widget build(BuildContext context) {
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
                const Center(
                  child: Text(
                    'วิธีเล่น',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                // กำหนดขนาดของรูปภาพให้เท่ากับขนาดของหน้าจอ
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/HowToPlay.png', // แทนที่ด้วยตำแหน่งของไฟล์รูปภาพ
                  fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
