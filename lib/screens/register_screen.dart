import 'package:blue_retro/model/console.dart';
import 'package:blue_retro/model/device.dart';
import 'package:blue_retro/screens/details_screen.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:blue_retro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class RegisterScreen extends StatefulWidget {
  final DiscoveredDevice device;

  const RegisterScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _sharedUtils = SharedUtils();
  final _controller = ScrollController();
  final _editController = TextEditingController();
  final ValueNotifier<Device?> _device = ValueNotifier(null);
  final _opacity = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
    _getDevice();
  }

  void _getDevice() async {
    final stored = await _sharedUtils.getDevice(widget.device.name);
    if (stored != null) {
      _device.value = stored;
    } else {
      _device.value = Device.getDefault(widget.device.id, widget.device.name);
    }
    final console = Console.values.firstWhere(
      (item) => _device.value?.name.contains(item.name) ?? false,
      orElse: () => Console.NONE,
    );
    _device.value!.consoleId = console.id;
    _device.value!.color = console.colors.first.$2.value;
    setState(() {});
    _controllerListener();
  }

  void _controllerListener() {
    final size = MediaQuery.of(context).size;
    _controller.addListener(() {
      final max = (size.width - kToolbarHeight) / 2;
      final range = 1 - (_controller.offset / max);
      _opacity.value = range < 0 ? 0 : range;
    });
  }

  void _saveDevice() {
    if (_device.value != null) {
      _sharedUtils.saveDevice(_device.value!).then((saved) {
        if (saved) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                device: widget.device,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: ValueListenableBuilder<Device?>(
            valueListenable: _device,
            builder: (context, device, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: device != null
                    ? NestedScrollView(
                        controller: _controller,
                        headerSliverBuilder: (context, scrolled) {
                          return [
                            SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                              sliver: SliverAppBar(
                                leading: BackButton(
                                  color: Color(device.color).contrast(),
                                ),
                                backgroundColor: Color(device.color),
                                elevation: 15,
                                expandedHeight: constraints.maxWidth,
                                floating: false,
                                pinned: true,
                                centerTitle: true,
                                title: Text(
                                  device.nickname.isNotEmpty
                                      ? device.nickname
                                      : device.name,
                                  style: TextStyle(
                                    color: Color(device.color).contrast(),
                                  ),
                                ),
                                flexibleSpace: ValueListenableBuilder<double>(
                                  valueListenable: _opacity,
                                  builder: (_, opacity, child) {
                                    return Opacity(
                                      opacity: opacity,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: kToolbarHeight,
                                            ),
                                            Image.asset(
                                              'assets/dongles/n64_0.png',
                                              width: 100,
                                              color: Color(device.color)
                                                  .contrast(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ];
                        },
                        body: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 55),
                                  DropdownButtonFormField<Console>(
                                    value: device.getConsole(),
                                    items: Console.values
                                        .map<DropdownMenuItem<Console>>((item) {
                                      return DropdownMenuItem<Console>(
                                        value: item,
                                        child: Text(item.longName),
                                      );
                                    }).toList(),
                                    onChanged: (console) {
                                      _device.value?.consoleId = console!.id;
                                      _device.value?.color =
                                          console!.colors[0].$2.value;
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 30),
                                  DropdownButtonFormField<(String, Color)>(
                                    value: device.getConsole().colors[0],
                                    items: device
                                        .getConsole()
                                        .colors
                                        .map<DropdownMenuItem<(String, Color)>>(
                                            (item) {
                                      return DropdownMenuItem<(String, Color)>(
                                        value: item,
                                        child: Text('Color: ${item.$1}'),
                                      );
                                    }).toList(),
                                    onChanged: (color) {
                                      _device.value?.color = color!.$2.value;
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 30),
                                  TextField(
                                    controller: _editController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('Nickname'),
                                    ),
                                    onChanged: (nickname) {
                                      _device.value?.nickname = nickname;
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _saveDevice(),
            label: const Text('Save Device'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
