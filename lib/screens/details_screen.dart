import 'dart:async';
import 'dart:convert';

import 'package:blue_retro/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends StatefulWidget {
  final DiscoveredDevice device;

  const DetailsScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _ble = FlutterReactiveBle();

  final _title = ValueNotifier('');
  final _loading = ValueNotifier(false);
  final _widgets = ValueNotifierList<Widget>([]);

  Stream<ConnectionStateUpdate>? _connect;
  StreamSubscription<ConnectionStateUpdate>? _connection;

  @override
  void initState() {
    super.initState();
    _connectDevice();
  }

  void _connectDevice() async {
    _loading.value = true;
    _title.value = 'Connecting...';
    _connect = _ble.connectToAdvertisingDevice(
      id: widget.device.id,
      connectionTimeout: const Duration(seconds: 5),
      withServices: [],
      prescanDuration: const Duration(seconds: 2),
    );

    print('CONNECT: $_connect');

    _connection = _connect?.listen((event) async {
      print('EVENT: $event');
      if (event.connectionState == DeviceConnectionState.connected) {
        print('CONNECTED');
        _title.value = 'Connected';

        if (Theme.of(context).platform == TargetPlatform.android) {
          await _ble.requestConnectionPriority(
            deviceId: widget.device.id,
            priority: ConnectionPriority.highPerformance,
          );
        }

        final services = await _ble.discoverServices(widget.device.id);
        final service = services.firstWhere(
          (element) => element.serviceId == Utils.brUuid[0],
        );

        final bdAddress = service.characteristics.get(Utils.brUuid[12]);
        final appVersion = service.characteristics.get(Utils.brUuid[9]);
        final deepSleep = service.characteristics.get(Utils.brUuid[7]);

        // ADDRESS
        final addressData = await _ble.readCharacteristic(
          Utils.genCharacteristic(bdAddress, widget.device),
        );

        final titleWidget = Text(
          'Device Address: ${Utils.getAddress(addressData)}',
        );
        _widgets.add(const SizedBox(height: 20));
        _widgets.add(titleWidget);
        _widgets.add(const SizedBox(height: 20));

        // APP VERSION
        try {
          _ble.characteristicValueStream.listen((event) {
            print('EVENTO: $event');
          });
          final versionDataFuture = _ble.readCharacteristic(
            Utils.genCharacteristic(appVersion, widget.device),
          );
          final versionData = await retry<List<int>>(
            10,
            () => versionDataFuture,
            eachDelay: const Duration(seconds: 1),
          );
          print('VERSION: $versionData');
          final filtered = versionData.takeWhile((value) => value > 0).toList();
          final title = utf8.decode(filtered);
          _title.value = title;

          print('TITLE: ${title.codeUnits}');
        } on Exception catch (_, error) {
          print('ERROR: $error');
        }

        // DEEP SLEEP
        final deepData = Utils.genCharacteristic(deepSleep, widget.device);
        await _ble.readCharacteristic(deepData);

        final deepButton = ElevatedButton(
          onPressed: () => _deepSleep(deepData),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Deep Sleep'),
          ),
        );
        _widgets.add(deepButton);
        _loading.value = false;
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        Navigator.of(context).pop();
      }
    });
  }

  void _deepSleep(QualifiedCharacteristic characteristic) async {
    _loading.value = true;
    final cmd = Uint8List(1);
    cmd[0] = Utils.cfg_cmd_sys_deep_sleep;

    await _ble.writeCharacteristicWithResponse(characteristic, value: cmd);
    _loading.value = false;
    _title.value = '${_title.value} - Deep Sleep';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _connection?.cancel();
        return true;
      },
      child: MultiValueListenableBuilder(
        valueListenables: [_loading, _title, _widgets],
        builder: (context, stream) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(title: Text(_title.value), centerTitle: true),
                body: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _widgets.value,
                  ),
                ),
              ),
              if (_loading.value)
                Container(
                  color: const Color(0x90000000),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

