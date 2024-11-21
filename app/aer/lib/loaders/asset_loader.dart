import 'package:flutter/material.dart';

Future<void> preloadAssets(BuildContext context, Function(String) updateLoadingText) async {
  List<String> assetPaths = [
    'lib/images/splash_screen_bg.png',
    'lib/images/clouds_bg.png',
    'lib/images/windturbine_bg.png',
    'lib/images/aer_logo.png',
    // Add other images or assets to preload here...
  ];

  for (String assetPath in assetPaths) {
    await _precacheImage(context, assetPath, updateLoadingText);
  }
}

Future<void> _precacheImage(BuildContext context, String imagePath, Function(String) updateLoadingText) async {
  updateLoadingText(imagePath.split('/').last);
  await Future.delayed(const Duration(milliseconds: 500)); // Adding a delay for the cooldown
  await precacheImage(AssetImage(imagePath), context);
}
