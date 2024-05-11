import 'package:contact_list_project/model/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/category_controller.dart';

import 'app_drawer_widget.dart';

/*
 *
 * this is category screen
 *
 * in this screen add,show,edit,delete category
 *
 * all the process manage using CategoryController
 */

class CategoryScreen extends StatelessWidget {
   CategoryScreen({Key? key}) : super(key: key);

   //this is GlobalKey add data Variable for check from state and manage it
  final GlobalKey<FormState> categoryKey = GlobalKey<FormState>();

   //this is GlobalKey update data Variable for check from state and manage it
   final GlobalKey<FormState> updateCategoryKey = GlobalKey<FormState>();


  String categoryName = '';

  //this put category controller this screen
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFF00BF8E),
        title: const Text('Create And Store Category',style: TextStyle(
          color: Colors.white,
        ),),
        centerTitle: true,
      ),

      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Form(
              key: categoryKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Category',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Category Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      categoryName = value!;
                    },
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (categoryKey.currentState!.validate()) {
                            categoryKey.currentState?.save();
                            categoryController.addCategory(categoryName);
                            categoryKey.currentState?.reset();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successfully Add Category $categoryName'),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),

                ],
              ),
            ),


            //show all category using list view
            Expanded(
              child: Obx(() =>
                  ListView.separated(
                  itemCount: categoryController.categories.length,
                  separatorBuilder:(context, index) {
                    return const Divider(
                      color: Colors.grey,
                      height: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    return ListTile(
                      title: Text(category.name.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.brown,fontSize: 16),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            color: const Color(0xFF00BF8E),
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              openDialogBox(context,category);
                            },
                          ),
                          IconButton(
                            color: const Color(0xFF00BF8E),
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              categoryController.deleteCategory(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Category has been Deleted!!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );

                  },
                ),

              ),


            ),


          ],
        ),
      ),
    );
  }

   /*
    *
    * this function is use for update category in Hive database
    *
    * in this function open Dialog box and have some field for upadate data
    *
    * @Parameter  index of category,context of widget and category object
    *
    * @Return Future Widget
    */
  Future openDialogBox(BuildContext context, Category category) {
       return  showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: const Text('Edit Category'),
             content: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Form(
                     key: updateCategoryKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         TextFormField(

                           decoration: const InputDecoration(
                             labelText: 'Enter Category',
                           ),
                             initialValue:category.name,
                           validator: (value) {
                             if (value!.isEmpty) {
                               return 'Please enter Category Name';
                             }
                             return null;
                           },
                           onSaved: (value) {
                             categoryName = value!;
                           },
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 16.0),
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 ElevatedButton(
                                   onPressed: () {
                                     if (updateCategoryKey.currentState!.validate()) {
                                       updateCategoryKey.currentState?.save();
                                       categoryController.updateCategory(Category(id: category.id,name: categoryName));
                                       updateCategoryKey.currentState?.reset();
                                       ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                           content: Text('Successfully Update Category $categoryName'),
                                         ),
                                       );
                                       Navigator.of(context).pop();
                                     }
                                   },
                                   child: const Text('Submit'),
                                 ),
                                 const SizedBox(width: 8), // Add some space between buttons
                                 OutlinedButton(
                                   onPressed: () {
                                     Navigator.of(context).pop(); // Close the dialog
                                   },
                                   child: const Text('Cancel'),
                                 ),
                               ],
                             ),
                           ),
                         ),

                       ],
                     ),
                   ),
                 ],
               ),
             ),
           );
         },
       );

  }
}
