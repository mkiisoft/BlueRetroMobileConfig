/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsDonglesGen {
  const $AssetsDonglesGen();

  AssetGenImage get gen0 => const AssetGenImage('assets/dongles/GEN_0.png');
  AssetGenImage get n640 => const AssetGenImage('assets/dongles/N64_0.png');
  AssetGenImage get n641 => const AssetGenImage('assets/dongles/N64_1.png');
  AssetGenImage get n642 => const AssetGenImage('assets/dongles/N64_2.png');
  AssetGenImage get ngc0 => const AssetGenImage('assets/dongles/NGC_0.png');
  AssetGenImage get pso0 => const AssetGenImage('assets/dongles/PSO_0.png');
}

class Assets {
  Assets._();

  static const $AssetsDonglesGen dongles = $AssetsDonglesGen();
  static const AssetGenImage retroLogo = AssetGenImage('assets/retro_logo.png');
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
