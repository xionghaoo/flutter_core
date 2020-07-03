import 'package:flutter/services.dart';

/// 设置状态栏为白色
setLightStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

/// 设置状态栏为黑色
setDarkStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}