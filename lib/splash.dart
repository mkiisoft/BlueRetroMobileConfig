import 'package:blue_retro/gen/assets.gen.dart';
import 'package:blue_retro/notifiers/app_notifier.dart';
import 'package:blue_retro/screens/home_screen.dart';
import 'package:blue_retro/utils/fade_route.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _shared = SharedUtils();
  final _loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() {
    _shared.getOption().then((option) {
      providerContainer.read(appNotifier.notifier).setOption(option);
      Navigator.of(context).pushReplacement(FadePageRoute(HomeScreen(context)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (context, loading, child) {
        return Center(
          child: Assets.retroLogo.image(
            width: 200,
            color: const Color(0xFF101010),
          ),
        );
      },
    );
  }
}
