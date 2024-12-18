import 'package:flutter/material.dart';

Future<void> preloadAssets(BuildContext context, Function(String) updateLoadingText) async {
  List<String> assetPaths = [
    'lib/images/splash_screen_bg.png',
    'lib/images/clouds_bg.png',
    'lib/images/windturbine_bg.png',
    'lib/images/aer_logo.png',
    'lib/images/cloud.png',
    'lib/images/clouds.png',
    'lib/images/storm.png',
    'lib/images/mist.png',
    'lib/images/sun.png',
    'lib/images/storm_bg.png',
    'lib/images/snow_bg.png',
    'lib/images/rain.png'
    // Add other images or assets to preload here...
  ];

  for (String assetPath in assetPaths) {
    await _precacheImage(context, assetPath, updateLoadingText);
  }
}

Future<void> _precacheImage(BuildContext context, String imagePath, Function(String) updateLoadingText) async {
  updateLoadingText(imagePath.split('/').last);
  await Future.delayed(const Duration(milliseconds: 500));
  await precacheImage(AssetImage(imagePath), context);
}
