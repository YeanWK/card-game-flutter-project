import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/ionicbond_providers.dart';
import 'providers/setting_provider.dart';
import 'screen/home_screen.dart';

void main() {
  // Lock screen orientation to landscape
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IonicProvider>(
            create: (context) => IonicProvider()),
        ChangeNotifierProvider<SettingProvider>(
            create: (context) => SettingProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Itim',
            scaffoldBackgroundColor: const Color(0xFFEAE9E8),
          ),
          home: const Home()),
    );
  }
}
