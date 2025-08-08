import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:modular_yoga_session_app/controllers/supabase_controller.dart';
import 'package:modular_yoga_session_app/controllers/splashController.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SupabaseController supabaseController = Get.put(SupabaseController());
    SplashController splashController = Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/asanTileImage.jpg',
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 50,),
              Text('Welcome To Your',style: Theme.of(context).textTheme.headlineLarge,),
              Text('Yoga Session App',style: Theme.of(context).textTheme.headlineLarge,),
            ],
          ),
        ),
      ),
    );
  }
}
