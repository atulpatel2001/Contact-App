import 'dart:io';

import 'package:contact_list_project/model/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contact_controller.dart';
import '../model/contact.dart';
import 'app_drawer_widget.dart';

/*
 * this is contact screen
 * in this screen show,edit,delete contact
 * all the process manage using ContactController
 */
class ContactListScreen extends StatelessWidget {
   ContactListScreen({Key? key}) : super(key: key);
  final ContactController contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BF8E),
        title: const Text(
          "Contact List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions:  [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(

                  radius: 20,
                  backgroundColor: const Color(0xFF00BF8E),
                  backgroundImage: const AssetImage('assets/filter.png'),
                  child:  GestureDetector(
                    onTap: (){
                      openBottomBox(context);
                    },
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF00BF8E),
                backgroundImage: AssetImage('assets/search.png'),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ContactListWidget(),
    );
  }

  /*
 *
 *
 * open bottom box
 */

  void openBottomBox(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'Filter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),


                ListView.builder(
                  shrinkWrap: true,
                  itemCount:contactController.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category category = contactController.categories[index];

                    return Obx(() => CheckboxListTile(
                      title: Text(category.name.toString()),
                      value: contactController.selectedCategories.contains(category.name.toString()),
                      onChanged: (bool? value) {
                        if (value != null) {
                          contactController.selectCategoryForFilter(category.name.toString());
                        }
                      },
                    ));


                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    contactController.reflectFilterCategoryFunction();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ContactListWidget extends StatelessWidget {
  ContactListWidget({super.key});

  //this is contact controller for manage all task
  final ContactController contactController = Get.put(ContactController());

  //this is GlobalKey Variable for check from state and manage it
  final GlobalKey<FormState> contactKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BF8E)),
                ),
                labelText: "Search",
              ),
              onChanged: (value) => {contactController.searchContacts(value)},
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.separated(
                itemCount: contactController.contacts.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.grey,
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  final Contact contact = contactController.contacts[index];

                  return Container(
                    color: Colors.white70,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: contact.imagePath != null &&
                                contact.imagePath!.isNotEmpty
                            ? FileImage(File(contact.imagePath!))
                                as ImageProvider<Object>?
                            : const AssetImage('assets/user.png'),
                      ),
                      title: Text(
                        "${contact.firstName} ${contact.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: Text(
                        "${contact.mobileNumber}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.brown,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            color: const Color(0xFF00BF8E),
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              openDialogBox(context, contact, index);
                            },
                          ),
                          IconButton(
                            color: const Color(0xFF00BF8E),
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              contactController.deleteAt(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Contact has been Deleted!!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /*
    *
    * this function is use for update contact in Hive database
    *
    * in this function open Dialog box and have some field for update data
    *
    * @Parameter  index of contact,context of widget and contact object
    *
    * @Return Future Widget
    */
  Future openDialogBox(BuildContext context, Contact contact, index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Contact'),
          content: SingleChildScrollView(
            child: Form(
              key: contactKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    initialValue: contact.firstName, // Pre-fill first name
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
                  TextFormField(
                    initialValue: contact.lastName,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
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
                  TextFormField(
                    initialValue: contact.mobileNumber,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
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
                  TextFormField(
                    initialValue: contact.email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    value: contact.category,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (contactKey.currentState!.validate()) {
                              contactKey.currentState?.save();

                              contactController.updateContact(
                                  index,
                                  Contact(
                                    firstName: firstName,
                                    lastName: lastName,
                                    mobileNumber: mobileNumber,
                                    email: email,
                                    category: category,
                                  ));

                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Successfully Update Contact $firstName'),
                                ),
                              );// Close the dialog
                            }
                          },
                          child: const Text('Submit'),
                        ),
                        const SizedBox(width: 8),
                        // Add some space between buttons
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



}
