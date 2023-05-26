import 'dart:async';

import 'package:blue_retro/gen/assets.gen.dart';
import 'package:blue_retro/l10n/app_localizations.dart';
import 'package:blue_retro/model/device.dart';
import 'package:blue_retro/notifiers/app_notifier.dart';
import 'package:blue_retro/notifiers/main_notifier.dart';
import 'package:blue_retro/screens/details_screen.dart';
import 'package:blue_retro/screens/register_screen.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:blue_retro/utils/utils.dart';
import 'package:blue_retro/widgets/action_settings.dart';
import 'package:blue_retro/widgets/action_toolbar.dart';
import 'package:blue_retro/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext context;

  const HomeScreen(this.context, {Key? key}) : super(key: key);

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
  Timer? _wait;

  final _searching = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() {
    _sharedUtils.getOption().then((option) {
      providerContainer.read(appNotifier.notifier).setOption(option);
    });
  }

  void _searchDevices() async {
    final bleStream = _ble
        .scanForDevices(
          scanMode: ScanMode.lowLatency,
          withServices: Utils.deviceId,
        )
        .timeout(const Duration(seconds: 5));

    _status = _ble.statusStream.listen((event) {
      if (event == BleStatus.ready) {
        _status!.cancel();
        _discover = bleStream.listen((device) async {
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
            _wait = Timer(const Duration(seconds: 2), () async {
              await _status!.cancel();
              await _discover!.cancel();
              _wait?.cancel();
              _searching.value = 0;
              _loading.value = false;
            });
            setState(() {});
          } else {
            _wait = Timer(const Duration(seconds: 10), () async {
              await _status!.cancel();
              await _discover!.cancel();
              _wait?.cancel();
              _searching.value = 0;
              _loading.value = false;
            });
          }
        }, onError: (error) {
          _status!.cancel();
          _discover!.cancel();
          _searching.value = 0;
          _loading.value = false;
        }, onDone: () {
          /* no-op */
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
    _searchDevices();
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
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: const ActionToolbar(ActionSettings()),
          body: ValueListenableBuilder<bool>(
              valueListenable: _loading,
              builder: (context, loading, child) {
                return Stack(
                  children: [
                    _devices.isNotEmpty
                        ? ListView(
                            padding: const EdgeInsets.all(20),
                            children: _devices.map((device) {
                              return InkResponse(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                              )
                                  .animate()
                                  .fadeIn(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.decelerate,
                                  )
                                  .slideY(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.decelerate,
                                  );
                            }).toList(),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.brLogoNamed.image(
                                  width: 300,
                                  color: const Color(0xFF303030),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VSpace(200),
                                CircularProgressIndicator(),
                              ],
                            ),
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
              label: Text(
                AppLocalizations.of(context)!.buttonSearchDevices,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
