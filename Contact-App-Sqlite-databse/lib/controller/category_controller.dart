import 'package:contact_list_project/repo/db_helper.dart';
import 'package:get/get.dart';

import '../model/category.dart';


/*
 * This is category controller for manage state of categories
 * extend a GetX controller class
 *
 * in this file manage whole crud operation using getx
 *
 *
 *
 */
class CategoryController extends GetxController {
  //categories List , this is observable list if any change in list automatically reflect in page.
  var categories = <Category>[].obs;



  /*
   * this is init methode for build controller
   * and load all category
   */
  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }


  /*
   * this loadCategories()  methode for retrive all
   * categories from Hive database
   *
   * Store in Observable List
   *
   * @Parameter :-No Parameter
   *
   * @Return void
   */

  void loadCategories() async {

    List<Map<String, dynamic>>? categoriesData = await DBHelper().getAllCategories();
    categories.value = categoriesData!.map((categoryData) => Category.fromJson(categoryData)).toList();
  }


  /*
   * this methode user for store category in Hive Database
   * Store in Observable List
   *
   * @Parameter Category Name
   *
   * @Return void
   *
   */
  void addCategory(String name) async {
    Category category = Category(name: name);
   await DBHelper().insertCategory(category);
    categories.add(category);
  }



  /*
   * this methode use for delete category in Hive Database
   * delete in Observable List
   *
   * @Parameter index of Databox
   *
   * @Return void
   */
  void deleteCategory(id) async {
    int? rowsAffected = await DBHelper().deleteCategory(id);
    categories.removeWhere((category) => category.id == id);
  }



  /*
   * this methode use for Update Category in Hive Database
   *
   * @Parameter index of Databox and  object of category
   *
   * @Return void
   */

  void updateCategory(Category category) async{
    DBHelper().updateCategory(category);
    loadCategories();
  }


}
