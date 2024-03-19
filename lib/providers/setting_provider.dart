import 'package:flutter/material.dart';
import 'dart:developer';

class SettingProvider extends ChangeNotifier {
  double volumnMusic = 0.5;
  double volumnSoundFx = 0.5;

  void setVolumnMusic(double volume) {
    volumnMusic = volume * 0.01;
    log("_volumnMusic$volumnMusic");
    notifyListeners();
  }

  void setVolumnSoundFx(double volume) {
    volumnSoundFx = volume * 0.01;
    log("_volumnSoundFx$volumnSoundFx");
    notifyListeners();
  }
}
