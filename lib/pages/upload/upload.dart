import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:modular_yoga_session_app/controllers/pick_files_controller.dart';
import 'package:modular_yoga_session_app/controllers/supabase_controller.dart';
import 'package:modular_yoga_session_app/pages/homePage/home_page.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    SupabaseController supabaseController = Get.put(SupabaseController());
    PickFilesController pickFilesController = Get.put(PickFilesController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leadingWidth: w / 15,
        title: Text(
          'Media Upload Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: (){
        //     },
        //     icon: Icon(
        //       Icons.more_vert,
        //       size: 32,
        //       color: Theme.of(context).colorScheme.secondary,
        //     ),
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(HomePage());
        },
        child: Icon(Icons.home),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h / 10),
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent.withOpacity(0.1),
                onTap: () async {
                  File? myJson = await pickFilesController.pickJsonFile();
                  if (myJson != null) {
                    supabaseController.uploadFileToSupabase(myJson);
                    Get.showSnackbar(
                      GetSnackBar(
                        borderRadius: 20,
                        message: 'JSON uploaded',
                        duration: Duration(seconds: 1),
                      ),
                    );
                    // Get.offAll(HomePage());
                  }
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsClass.jsonLogoSvg,
                        width: w / 5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Upload JSON',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h / 10),
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent.withOpacity(0.1),
                onTap: () async {
                  Map<String, dynamic>? myAudio = await pickFilesController
                      .pickImageFromGallery();
                  if (myAudio != null) {
                    supabaseController.uploadImageToSupabase(
                      myAudio['bytes'],
                      myAudio['name'],
                    );
                    Get.showSnackbar(
                      GetSnackBar(
                        borderRadius: 20,
                        message: 'Image uploaded',
                        duration: Duration(seconds: 1),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                    // Get.offAll(HomePage());
                  }
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsClass.imageLogoSvg,
                        width: w / 6,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Upload Image',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h / 10),
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent.withOpacity(0.1),
                onTap: () async {
                  Map<String, dynamic>? myAudio = await pickFilesController
                      .pickAudioFile();
                  if (myAudio != null) {
                    supabaseController.uploadAudioToSupabase(
                      myAudio['bytes'],
                      myAudio['name'],
                    );
                    Get.showSnackbar(
                      GetSnackBar(
                        borderRadius: 20,
                        message: 'Audio uploaded',
                        duration: Duration(seconds: 1),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.background,
                      ),
                    );
                    // Get.offAll(HomePage());
                  }
                },
                child: Container(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AssetsClass.audioLogoSvg,
                        width: w / 5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Upload Audio',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h / 10),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   height: h / 5,
              //   width: w / 1,
              //   color: Theme.of(context).colorScheme.primaryContainer,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'No Json uploaded Or re-upload new Json.',
              //         style: Theme.of(context).textTheme.headlineSmall,
              //       ),
              //       SizedBox(height: 10),
              //       Text(
              //         'Click on top right corner or Json icon.',
              //         style: Theme.of(context).textTheme.headlineSmall,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
