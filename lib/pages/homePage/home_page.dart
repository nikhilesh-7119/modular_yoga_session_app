import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/controllers/supabase_controller.dart';
import 'package:modular_yoga_session_app/pages/homePage/widgets/asanTIle.dart';
import 'package:modular_yoga_session_app/pages/upload/upload.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SupabaseController supabaseController = Get.put(SupabaseController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Home'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'developer') {
                Get.to(Upload());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                child: Text('Developer Settings'),
                value: 'developer',
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final urls = supabaseController.jsonUrls;

        if (urls.isEmpty) {
          return const Center(child: Text('No Json found'));
        }

        return ListView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            final jsonUrl = urls[index];
            return Asantile(jsonUrl: jsonUrl,);
          },
        );
      }),
    );
  }
  
}
