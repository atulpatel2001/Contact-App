import 'dart:io';

import 'package:contact_list_project/model/category.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../model/contact.dart';
import '../repo/db_helper.dart';

/*
 * This is Contact controller for manage state of Contacts
 * extend a GetX controller class
 *
 * in this file manage whole crud operation using getx
 *
 *
 *
 */
class ContactController extends GetxController {

  //Instance of ImagePicker
  final ImagePicker imagePicker = ImagePicker();


  //categories List , this is observable list if any change in list automatically reflect in page.
  var categories = <Category>[].obs;


  //contacts List , this is observable list if any change in list automatically reflect in page.
  var contacts = <Contact>[].obs;


  // For Filter Category Name Store in This Variable
  List<String> selectedCategories = <String>[].obs;


  //Selected Image  Byte array Store In this Variable
  Rx<XFile?> selectedImage = Rx<XFile?>(null);



  /*
   * this is init methode for build controller
   * and load all contacts
   */
  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadContacts();
  }


  /*
   *in this function check list time call this function on  onChanged event in Check box
   *
   * update selectCategory List
   *
   * @Parameter :-categoryName
   *
   * @Return void
   */
  void selectCategoryForFilter(String categoryName) {
    if (selectedCategories.contains(categoryName)) {
      selectedCategories.remove(categoryName);
    } else {
      selectedCategories.add(categoryName);
    }
    update();
  }


  /*
   * For Apply Filter In page and Update Contacts List
   *
   * @Parameter :-
   *
   * @Return:-
   */


  void reflectFilterCategoryFunction () async{
    loadContacts();
    try {
      if (selectedCategories.isEmpty) {
        contacts.value = await getContacts();
      } else {
        List<Contact> filteredContacts = [];
        for (Contact contact in contacts) {
          if (selectedCategories.contains(contact.category)) {
            filteredContacts.add(contact);
          }
        }
        contacts.value = filteredContacts;
      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }

  /*
   * this loadCategories()  methode for retrieve all
   * categories from Hive database
   *
   * Store in Observable List
   */

  void loadCategories() async {
    try {
      List<Map<String, dynamic>>? categoriesData = await DBHelper().getAllCategories();
      categories.value = categoriesData!.map((categoryData) => Category.fromJson(categoryData)).toList();
    } catch (e) {
      printInfo(info: e.toString());
    }
  }


  /*
   * this loadContacts()  methode for retrieve all
   * contacts from Hive database
   *
   * Store in Observable List
   *
   * @Parameter :-No
   * @Return void
   *
   */

  void loadContacts() async {
    try {
      List<Map<String, dynamic>>? allContacts = await DBHelper().getAllContacts();
      contacts.value =allContacts!.map((contact) => Contact.fromJson(contact)).toList();
    } catch (e) {
      printInfo(info: e.toString());
    }
  }



  /*
   * this methode user for store contact in Hive Database
   * Store in Observable List
   *
   * @Parameter object of contact
   *
   * @Return void
   */

  void addContact(Contact contact) async {
    try {

      XFile? selectedImageValue = selectedImage.value;

      if (selectedImageValue != null) {
        String path = await saveImageToLocalStorage(selectedImageValue);
        contact.imagePath = path;
        DBHelper().insertContact(contact);
        selectedImage.value = null;
        contacts.add(contact);

      } else {

        selectedImage.value = null;
        DBHelper().insertContact(contact);
        contacts.add(contact);

      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }


  /*
   * this methode use for delete contact in Hive Database
   * delete in Observable List
   *
   * @Parameter contact index
   *
   * @Return void
   */
  Future<void> deleteAt(id) async {
    try {
      int? rowsAffected = await DBHelper().deleteContact(id);
      contacts.removeWhere((contact) => contact.id == id);
    } catch (e) {
      printInfo(info: e.toString());
    }
  }


  /*
   * this methode use for Update contact in Hive Database
   *
   * @Parameter index of Databox and  object of contact
   *
   * @Return void
   */
  void updateContact(Contact contact) async {
    try {
      DBHelper().updateContact(contact);
     loadContacts();
    } catch (e) {
      printInfo(info: e.toString());
    }
  }


  /*
   *
   * this function use for Get contact from Hive Database
   *
   *  and add in a contact
   *
   * @Parameter  :- No Parameter
   *
   * @Return Type :-void
   */
  Future<List<Contact>> getContacts() async {
    List<Map<String, dynamic>>? allContacts = await DBHelper().getAllContacts();
    List<Contact> lists =allContacts!.map((contact) => Contact.fromJson(contact)).toList();
    return lists;
  }



  /*
   *
   * this function use for search contact from list
   *
   * and and add in a contact
   *
   * @Parameter   searchString name if it is name ,category and etc..
   *
   * @Return Type :-void
   */
  void searchContacts(String searchString) async {
    try {
      if (searchString.isEmpty) {
        // Wait for getContacts() Future to complete and assign contacts
        contacts.assignAll(await getContacts());
      } else {
        // Wait for getContacts() Future to complete and filter contacts
        List<Contact> allContacts = await getContacts();
        contacts.assignAll(allContacts.where((contact) =>
        (contact.firstName ?? '')
            .toLowerCase()
            .contains(searchString.toLowerCase()) ||
            (contact.lastName ?? '')
                .toLowerCase()
                .contains(searchString.toLowerCase()) ||
            (contact.mobileNumber ?? '')
                .toLowerCase()
                .contains(searchString.toLowerCase()) ||
            (contact.email ?? '')
                .toLowerCase()
                .contains(searchString.toLowerCase()) ||
            (contact.category ?? '')
                .toLowerCase()
                .contains(searchString.toLowerCase())));
      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }



  /*
   * this function is use for open gallery and select image show
   *
   * @Parameter: No Parameter
   *
   * @Return :void
   */

  void getImageFromGallery() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = pickedFile;
      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }



  /*
   * this function is use for open camera and select image show
   *
   * @Parameter: No Parameter
   *
   * @Return :void
   */

  void getImageFromCamera() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        selectedImage.value = pickedFile;
      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }



  /*
   * this function is use for Store a selected image from gallery and camera in local device folder
   *
   * this function use path provider
   *
   * @Parameter: No Parameter
   *
   * @Return :void
   */
  Future<String> saveImageToLocalStorage(XFile pickedImage) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String folderPath = appDocDir.path;
    Directory(folderPath).createSync(recursive: true);
    String fileName = pickedImage.path.split('/').last;
    String filePath = '$folderPath/$fileName';
    File imageFile = File(filePath);
    await imageFile.writeAsBytes(await pickedImage.readAsBytes());
    return filePath;
  }
}
