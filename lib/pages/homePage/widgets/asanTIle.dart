import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:modular_yoga_session_app/pages/displayPage/display_page.dart';


class Asantile extends StatelessWidget {
  final String jsonUrl;
  const Asantile({super.key, required this.jsonUrl});
  

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final d = sqrt(w * w + h * h);
    return InkWell(
      onTap: () {
        Get.to(DisplayPage(jsonUrl: jsonUrl));
      },
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent.withOpacity(0.1),
      child: Container(
        margin: EdgeInsets.all(d / 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        padding: EdgeInsets.all(d / 60),
        width: d / 4,
        height: d / 5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                width: d / 6,
                height: d / 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    AssetsClass.asanTileImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: d / 80),
              FutureBuilder<String>(
                future: getTitleFromJsonUrl(jsonUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (snapshot.hasError) {
                    return const Text('Error loading title');
                  } else {
                    return Text(snapshot.data ?? 'No title');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getTitleFromJsonUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return jsonMap['metadata']['title'];
      } else {
        print('Failed to load JSON: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching JSON title: $e');
    }
    return 'Default Asan';
  }
}
