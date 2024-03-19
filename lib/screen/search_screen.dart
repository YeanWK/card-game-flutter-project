import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting_provider.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ionicbondList;

  const SearchScreen({
    super.key,
    required this.ionicbondList,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _foundIonicFormular = [];
  final _focusNode = FocusNode();
  late final soundFx = AudioPlayer();

  void playsoundFx() async {
    var settingProvider = context.read<SettingProvider>();
    soundFx.play(AssetSource("sounds/select.mp3"));
    soundFx.setVolume(settingProvider.volumnSoundFx);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _foundIonicFormular = widget.ionicbondList;
      debugPrint(widget.ionicbondList.toString());
    });
  }

  onSearch(String search) {
    debugPrint(search);
    //ค้นหาionicbond_formulas ที่ขึ้นต้นด้วยตัวอักษรที่เราพิมพ์
    setState(() {
      _foundIonicFormular = widget.ionicbondList
          .where((found) => found['ionicbond_formulas'].startsWith(search))
          .toList();
    });
    debugPrint(widget.ionicbondList.toString());
  }

  @override
  void dispose() {
    soundFx.dispose();
    super.dispose();
    debugPrint("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                        onPressed: () async {
                          playsoundFx();
                          _focusNode.unfocus();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'พันธะไอออนิก',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                // color: Colors.white,
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (value) => onSearch(value),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey.shade300),
                      hintText: "ค้นหาสูตรสารประกอบไอออนิก"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: _foundIonicFormular.length,
                itemBuilder: (context, index) => Card(
                  color: const Color(0xFF6B76BE),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(
                      _foundIonicFormular[index]['ionicbond_formulas'],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      _foundIonicFormular[index]['ionicbond_name'],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
