import 'package:flutter/material.dart';

// บอกอุปกรณ์ที่ใช้อยู่มีขนาดเท่าไร
Size displaySize(BuildContext context) {
  debugPrint('Size = ${MediaQuery.of(context).size}');
  return MediaQuery.of(context).size;
}

// บอกขนาดความสูงของหน้าจอ
double displayHeight(BuildContext context) {
  debugPrint('Heigt = ${displaySize(context).height}');
  return displaySize(context).height;
}

// บอกขนาดความกว้างของหน้าจอ
double displayWidth(BuildContext context) {
  debugPrint('Width = ${displaySize(context).width}');
  return displaySize(context).width;
}
