import 'dart:convert';

import 'package:blue_retro/model/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedUtils {

  Future<Device?> getDevice(String name) async {
    final shared = await SharedPreferences.getInstance();
    final data = shared.getString(name);
    if (data != null) {
      final json = jsonDecode(data);
      return Device.fromJson(json, name);
    }
    return null;
  }

  Future<bool> saveDevice(Device device) async {
    final shared = await SharedPreferences.getInstance();
    final json = device.toJson(device.name);
    final data = jsonEncode(json);
    return shared.setString(device.name, data);
  }
}