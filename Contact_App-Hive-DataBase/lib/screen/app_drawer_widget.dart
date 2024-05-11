import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
 *
 * this class user constant component for multiple screen
 * this drawer for list out button for navigate to other screen
 */

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(

        padding: EdgeInsets.zero,
        children: [



          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF00BF8E),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile1.jpg'),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),


          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.toNamed("/home");
            },
          ),


          ListTile(
            title: const Text('Add Category'),
            onTap: () {
              Get.toNamed("/category");
            },
          ),



          ListTile(
            title: const Text('Add Contact'),
            onTap: () {
              Get.toNamed("/add-contact");
            },
          ),


          ListTile(
            title: const Text('Contact List'),
            onTap: () {
              Get.toNamed("/contact-list");
            },
          ),
        ],
      ),
    );
  }
}
