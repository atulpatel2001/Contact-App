/*
 * Contact Model
 * It is represent of Hive DataBox because put some hive configuration
 */



class Contact {

  int? id;

  String? firstName;

  String? lastName;

  String? mobileNumber;

  String? email;

  String? category;

  String? imagePath;

  Contact(

      { this.id,this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.category,this.imagePath});

  Contact.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    category = json['category'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['category'] = category;
    data['imagePath'] = imagePath;
    return data;
  }
}