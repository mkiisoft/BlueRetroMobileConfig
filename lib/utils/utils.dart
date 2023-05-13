import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Utils {
  static final deviceId = [
    Uuid.parse('0000180f-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('00830f56-5180-fab0-314b-2fa176799a56'),
  ];

  static final brUuid = [
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a00"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a01"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a02"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a03"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a04"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a05"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a06"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a07"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a08"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a09"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a0a"),
    Uuid.parse("56830f56-5180-fab0-314b-2fa176799a0b"),
    Uuid.parse('56830f56-5180-fab0-314b-2fa176799a0c'),
  ];

  static const cfg_cmd_get_abi_ver = 0x01;
  static const cfg_cmd_get_fw_ver = 0x02;
  static const cfg_cmd_get_bdaddr = 0x03;
  static const cfg_cmd_get_gameid = 0x04;
  static const cfg_cmd_get_cfg_src = 0x05;
  static const cfg_cmd_get_file = 0x06;
  static const cfg_cmd_set_default_cfg = 0x10;
  static const cfg_cmd_set_gameid_cfg = 0x11;
  static const cfg_cmd_open_dir = 0x12;
  static const cfg_cmd_close_dir = 0x13;
  static const cfg_cmd_del_file = 0x14;
  static const cfg_cmd_sys_deep_sleep = 0x37;
  static const cfg_cmd_sys_reset = 0x38;
  static const cfg_cmd_sys_factory = 0x39;
  static const cfg_cmd_ota_end = 0x5A;
  static const cfg_cmd_ota_start = 0xA5;
  static const cfg_cmd_ota_abort = 0xDE;

  static QualifiedCharacteristic genCharacteristic(
    DiscoveredCharacteristic characteristic,
    DiscoveredDevice device,
  ) {
    return QualifiedCharacteristic(
      characteristicId: characteristic.characteristicId,
      serviceId: characteristic.serviceId,
      deviceId: device.id,
    );
  }

  static String getAddress(List<int> addressData) {
    return '${addressData[5].toRadixString(16).padLeft(2, '0')}:'
        '${addressData[4].toRadixString(16).padLeft(2, '0')}:'
        '${addressData[3].toRadixString(16).padLeft(2, '0')}:'
        '${addressData[2].toRadixString(16).padLeft(2, '0')}:'
        '${addressData[1].toRadixString(16).padLeft(2, '0')}:'
        '${addressData[0].toRadixString(16).padLeft(2, '0')}';
  }
}

extension BleUtils on List<DiscoveredCharacteristic> {
  DiscoveredCharacteristic get(Uuid uuid) {
    return firstWhere((element) => element.characteristicId == uuid);
  }
}

extension StringUtils on String {
  String alpha() => replaceAll("[^\\p{IsAlphabetic}\\p{IsDigit}]", "");
}

extension ColorUtils on Color {
  Color contrast() => (red.toDouble() * 0.299 +
              green.toDouble() * 0.587 +
              blue.toDouble() * 0.114) >
          186
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> value) : super(value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}

class MultiValueListenableBuilder extends StatelessWidget {
  final List<ValueNotifier> valueListenables;
  final Widget Function(BuildContext, List values) builder;

  const MultiValueListenableBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _create(valueListenables, context);
  }

  Widget _create(
    List<ValueNotifier> notifiers,
    BuildContext context,
  ) {
    if (notifiers.isEmpty) {
      return builder(context, valueListenables.map((e) => e.value).toList());
    }
    final copy = [...notifiers];
    final notifier = copy.removeAt(0);
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, __, ___) => _create(copy, _),
      child: _create(copy, context),
    );
  }
}

typedef FutureGenerator<T> = Future<T> Function();

Future<T> retry<T>(
  int retries,
  FutureGenerator aFuture, {
  Duration? delay,
  Duration? eachDelay,
}) async {
  try {
    return await aFuture();
  } catch (e) {
    print('RETRIES: $retries');
    if (retries > 1) {
      if (delay != null) {
        await Future.delayed(delay);
      }
      if (eachDelay != null) {
        await Future.delayed(eachDelay);
      }
      return retry(retries - 1, aFuture, eachDelay: eachDelay);
    }
    rethrow;
  }
}
