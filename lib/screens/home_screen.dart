import 'dart:async';

import 'package:blue_retro/model/device.dart';
import 'package:blue_retro/screens/details_screen.dart';
import 'package:blue_retro/screens/register_screen.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:blue_retro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sharedUtils = SharedUtils();
  final _loading = ValueNotifier(false);

  final _ble = FlutterReactiveBle();
  final _devices = <(Device, DiscoveredDevice)>[];

  final _ids = <String>[];
  StreamSubscription<BleStatus>? _status;
  StreamSubscription<DiscoveredDevice>? _discover;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  Timer? _wait;

  final _searching = ValueNotifier(0);

  void _searchDevices() async {
    print('IS_HERE');
    _status = _ble.statusStream.listen((event) {
      print('EVENT: $event');
      if (event == BleStatus.ready) {
        _discover = _ble
            .scanForDevices(
              scanMode: ScanMode.lowLatency,
              withServices: Utils.deviceId,
            )
            .timeout(const Duration(seconds: 5))
            .listen((device) async {
          print('DEVICES: $device');
          if (!_ids.contains(device.name)) {
            _wait?.cancel();
            _ids.add(device.name);
            final stored = await _sharedUtils.getDevice(device.name);
            if (stored != null) {
              _devices.add((stored, device));
            } else {
              final getDefault = Device.getDefault(device.id, device.name);
              _devices.add((getDefault, device));
            }
            _wait = Timer(const Duration(seconds: 2), () {
              _wait?.cancel();
              _discover!.cancel();
              _status!.cancel();
              _searching.value = 0;
              _loading.value = false;
            });
            setState(() {});
          } else {
            _wait = Timer(const Duration(seconds: 10), () {
              _wait?.cancel();
              _status!.cancel();
              _discover!.cancel();
              _searching.value = 0;
              _loading.value = false;
            });
          }
        }, onError: (error) {
          print('ERROR: $error');
          _status!.cancel();
          _discover!.cancel();
          _searching.value = 0;
          _loading.value = false;
        }, onDone: () {
          print('DONE!');
        });
      }
    });
  }

  void _permission() async {
    _ids.clear();
    _devices.clear();
    _loading.value = true;
    _searching.value = 1;
    const permission = Permission.location;
    final granted = await permission.isGranted;
    if (granted) {
      _searchDevices();
    } else {
      final requested = await permission.request();
      if (requested.isGranted) {
        _searchDevices();
      }
    }

  }

  void _connect(DiscoveredDevice device, bool registered) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => registered
              ? DetailsScreen(device: device)
              : RegisterScreen(device: device)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlueRetro Config'),
        actions: [
          _connection != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async => await _connection!.cancel(),
                )
              : const SizedBox(),
        ],
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: _loading,
          builder: (context, loading, child) {
            return Stack(
              children: [
                _devices.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: _devices.map((device) {
                          return InkResponse(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                elevation: 10,
                                color: Colors.grey[900],
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    device.$1.nickname.isNotEmpty
                                        ? device.$1.nickname
                                        : device.$1.name,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              _connect(
                                device.$2,
                                device.$1.nickname.isNotEmpty,
                              );
                            },
                          );
                        }).toList(),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/retro_logo.png',
                              width: 200,
                              color: const Color(0xFF101010),
                            ),
                            const SizedBox(height: kToolbarHeight),
                          ],
                        ),
                      ),
                if (loading)
                  IgnorePointer(
                    ignoring: false,
                    child: Container(
                      color: const Color(0x90000000),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            );
          }),
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: _searching,
        builder: (_, searching, child) {
          Widget? widget;
          switch (searching) {
            case 0:
              widget = child;
              break;
            case 1:
            default:
              widget = const SizedBox();
              break;
          }
          return widget!;
        },
        child: FloatingActionButton.extended(
          onPressed: _permission,
          label: const Text(
            'Search for Devices',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
