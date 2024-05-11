import 'dart:io';

import 'package:contact_list_project/controller/contact_controller.dart';
import 'package:contact_list_project/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer_widget.dart';

/*
 *
 *
 * this screen use for add contact in hive database
 */
class AddContactScreen extends StatelessWidget {
  AddContactScreen({Key? key}) : super(key: key);

  //this is GlobalKey Variable for check from state and manage it

  final GlobalKey<FormState> contactKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? category;
  String? imageName;

  // this contact controller put in this screen
  final ContactController contactController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: AppBar(
        title: const Text(
          'Create And Store Category',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00BF8E),
      ),

      //Drawer use Drawer Component
      drawer: const AppDrawer(),

      //body Part
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              //This Container use for Show Image And Also Select Image from Gallery
              Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Obx(() {
                    //variable is observable Variable
                    final selectedImage = contactController.selectedImage.value;

                    return GestureDetector(
                      onTap: () {
                        showOptions(context);  //call Function For Open Pop Box For Select option
                      },

                      child: CircleAvatar(
                        backgroundColor:
                        selectedImage != null ? null : Colors.grey,
                        backgroundImage: selectedImage != null
                            ? FileImage(File(selectedImage.path))
                            : null,
                        child: selectedImage == null
                            ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                            : null,
                      ),

                    );
                  })),


              const SizedBox(height: 16),

              Form(
                key: contactKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    // First Name TextFormField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstName = value;
                      },
                    ),


                    const SizedBox(height: 16),
                    // Last Name TextFormField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Last Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastName = value;
                      },
                    ),

                    //Mobile Number TextFormField
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Mobile Number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        mobileNumber = value;
                      },
                    ),
                    const SizedBox(height: 16),

                    //Email TextFormField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),

                    //Category DropDown
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      value: category,
                      onChanged: (value) {
                        category = value;
                      },
                      items: contactController.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(category.name.toString()),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Category';
                        }
                        return null;
                      },
                    ),


                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (contactKey.currentState!.validate()) {
                    contactKey.currentState?.save();
                    contactController.addContact(Contact(
                      category: category,
                      email: email,
                      firstName: firstName,
                      lastName: lastName,
                      mobileNumber: mobileNumber,
                    ));

                    Get.toNamed("/contact-list");
                    contactKey.currentState?.reset();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully Add Contact'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
   *
   * This function is use for open popup box and select image source and select image
   *
   * @Parameter:- take current widget context
   *
   * @Return:-Future<Void>
   */
  Future<void> showOptions(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [

          //Gallery Source
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              contactController.getImageFromGallery();
            },
          ),

          //Camera Source
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              contactController.getImageFromCamera();
            },
          ),


        ],
      ),
    );
  }
}


//
// CircleAvatar(
// radius: 50,
// backgroundImage: selectedImage == null ?
// const AssetImage("assets/user.png"):
// FileImage(File(selectedImage.path)) as ImageProvider,
// )