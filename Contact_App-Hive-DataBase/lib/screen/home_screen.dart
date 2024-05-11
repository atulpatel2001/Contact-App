import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00BF8E),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/contact-us.jpg', width: 150, height: 150),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed("/add-contact");
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Contact'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed("/contact-list");
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('Contacts'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/add-contact");
        },

        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
