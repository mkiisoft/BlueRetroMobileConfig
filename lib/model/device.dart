import 'dart:ui';

import 'package:blue_retro/model/console.dart';

class Device {
  final String deviceId;
  final String name;
  String nickname = 'BlueRetro';
  int consoleId = 0;
  int gamepadId = 0;
  int color = const Color(0xFF2196F3).value;
  String asset = 'assets/dongles/N64_0.png';

  Device._(
    this.deviceId,
    this.name,
    this.nickname,
    this.consoleId,
    this.gamepadId,
    this.color,
    this.asset,
  );

  void setNickname(String nickname) {
    this.nickname = nickname;
  }

  void setConsoleId(int consoleId) {
    this.consoleId = consoleId;
  }

  void setGamepadId(int gamepadId) {
    this.gamepadId = gamepadId;
  }

  void setColor(int color) {
    this.color = color;
  }

  void setAsset(String asset) {
    this.asset = asset;
  }

  Console getConsole() =>
      Console.values.firstWhere((item) => item.id == consoleId);

  factory Device.fromJson(Map<String, dynamic> json, String name) {
    return Device._(
      json[name]['deviceId'],
      json[name]['name'],
      json[name]['nickname'],
      json[name]['consoleId'],
      json[name]['gamepadId'],
      json[name]['color'],
      json[name]['asset'],
    );
  }

  factory Device.getDefault(String deviceId, String name) {
    return Device._(
      deviceId,
      name,
      '',
      0,
      0,
      const Color(0xFF2196F3).value,
      'assets/dongles/N64_0.png',
    );
  }

  Map<String, dynamic> toJson(String name) => {
        name: {
          'deviceId': deviceId,
          'name': name,
          'nickname': nickname,
          'consoleId': consoleId,
          'gamepadId': gamepadId,
          'color': color,
          'asset': asset,
        }
      };
}
