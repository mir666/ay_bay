import 'package:ay_bay/app/app_config.dart';
import 'package:ay_bay/app/app_path.dart';
import 'package:ay_bay/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    Get.offAndToNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E2656), Color(0xFF1F53BC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              SvgPicture.asset(AssetsPath.logoSvg),
              SizedBox(height: 36),
              CircularProgressIndicator(color: Colors.white,),
              Spacer(),
              Wrap(
                children: [
                  Text(
                    'ভার্সন ${AppConfig.currentAppVersion}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}