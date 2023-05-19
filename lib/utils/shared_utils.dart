import 'dart:convert';

import 'package:blue_retro/model/device.dart';
import 'package:blue_retro/model/option.dart';
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

  Future<Option> getOption() async {
    final shared = await SharedPreferences.getInstance();
    final decode = shared.getString(keyOption);
    if (decode != null) {
      final json = jsonDecode(decode);
      return Option.fromJson(json);
    }
    return Option.getDefault();
  }

  Future<void> setOption(Option option) async {
    final shared = await SharedPreferences.getInstance();
    final encode = option.toJson();
    final json = jsonEncode(encode);
    shared.setString(keyOption, json);
  }

  static const keyOption = "key_option";
}