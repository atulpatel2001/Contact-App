/*
 *
 * main dart File
 *
 * Application Start From this file
 */

import 'dart:io';

import 'package:contact_list_project/model/category.dart';
import 'package:contact_list_project/model/contact.dart';
import 'package:contact_list_project/screen/add_contact_screen.dart';
import 'package:contact_list_project/screen/category_screen.dart';
import 'package:contact_list_project/screen/home_screen.dart';
import 'package:contact_list_project/screen/list_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //For Certificate
  HttpOverrides.global = MyHttpOverrides();

  //For get Current directory
  final appDocumentDir = await getApplicationDocumentsDirectory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      defaultTransition: Transition.leftToRight,
      getPages: [
        GetPage(name: "/home", page: () =>  const HomeScreen()),
        GetPage(name: "/category", page: () => CategoryScreen()),
        GetPage(name: "/add-contact", page: () => AddContactScreen()),
        GetPage(name: "/contact-list", page: () =>  ContactListScreen()),

      ],
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
