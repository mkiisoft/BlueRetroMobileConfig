import 'package:blue_retro/gen/assets.gen.dart';
import 'package:blue_retro/notifiers/app_notifier.dart';
import 'package:blue_retro/notifiers/main_notifier.dart';
import 'package:blue_retro/screens/home_screen.dart';
import 'package:blue_retro/utils/fade_route.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:blue_retro/widgets/widget_utils.dart';
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
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: _loading,
        builder: (context, loading, child) {
          return Column(
            children: [
              const VSpace(100),
              Expanded(
                child: Center(
                  child: Assets.brLogoNamed.image(
                    width: 300,
                    color: const Color(0xFF505050),
                  ),
                ),
              ),
              const StyledProgressBar(),
              const VSpace(80),
            ],
          );
        },
      ),
    );
  }
}

