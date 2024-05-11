import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
    var box = Hive.box("category");
    List<Category> lists = box.values.cast<Category>().toList();
    categories.value = lists;
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
    var newCategory = Category(name: name);
    Box dataBox = Hive.box('category');
    await dataBox.add(newCategory);
    categories.add(newCategory);
  }



  /*
   * this methode use for delete category in Hive Database
   * delete in Observable List
   *
   * @Parameter index of Databox
   *
   * @Return void
   */
  void deleteCategory(index) async {
    var box = Hive.box("category");
    await box.deleteAt(index);
    categories.removeAt(index);
  }



  /*
   * this methode use for Update Category in Hive Database
   *
   * @Parameter index of Databox and  object of category
   *
   * @Return void
   */

  void updateCategory(Category category, int index) async{
    var box = Hive.box("category");
    Category oldCategory = box.getAt(index)!;
    oldCategory.name=category.name;
    await box.putAt(index, oldCategory);


  }


}
