/*
 * Contact Model
 * It is represent of Hive DataBox because put some hive configuration
 */

import 'package:hive/hive.dart';
part 'contact.g.dart';
@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  String? firstName;
  @HiveField(1)
  String? lastName;
  @HiveField(2)
  String? mobileNumber;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? category;
  @HiveField(5)
  String? imagePath;

  Contact(
      {this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.category,this.imagePath});

  Contact.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    category = json['category'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['category'] = category;
    data['imagePath'] = imagePath;
    return data;
  }
}