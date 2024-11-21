import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aer/loaders/asset_loader.dart'; // Import the asset loader

import 'package:aer/pages/home.dart';

class BackgroundImagePage extends StatefulWidget {
  const BackgroundImagePage({Key? key}) : super(key: key);

  @override
  _BackgroundImagePageState createState() => _BackgroundImagePageState();
}

class _BackgroundImagePageState extends State<BackgroundImagePage> with TickerProviderStateMixin {
  final List<String> _loadingMessages = [];
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(_controller);

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    preloadAssets(context, (fileName) {
      setState(() {
        _loadingMessages.add(fileName);
      });

      _controller.forward(from: 0).then((_) {
        _fadeController.forward(from: 0).then((_) {
          if (_loadingMessages.isNotEmpty) {
            setState(() {
              _loadingMessages.removeAt(0);
            });
            _fadeController.reset();
          }
        });
      });
    }).then((_) {
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeatherPage()), // Replace with your destination page
        );
      });
    }).catchError((error) {
      print("Error preloading assets: $error");
    });
  }

  Widget _buildLoadingMessage(BuildContext context, int index) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "Loading ${_loadingMessages[index]}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/splash_screen_bg.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_loadingMessages.length, (index) => _buildLoadingMessage(context, index)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
