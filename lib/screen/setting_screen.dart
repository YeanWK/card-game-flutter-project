import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting_provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double _valueMusic = 0;
  double _valuefx = 0;
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
    return Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
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
                      'ตั้งค่า',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF6B76BE),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Music",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Sound Fx",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Slider(
                            value: settingProvider.volumnMusic * 100,
                            min: 0.0,
                            max: 100.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            thumbColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _valueMusic = value;
                                settingProvider.setVolumnMusic(_valueMusic);
                                debugPrint("_valueMusic$_valueMusic");
                              });
                            },
                          ),
                          Slider(
                            value: settingProvider.volumnSoundFx * 100,
                            min: 0.0,
                            max: 100.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            thumbColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _valuefx = value;
                                settingProvider.setVolumnSoundFx(_valuefx);
                                debugPrint("_valuefx$_valuefx");
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
