import 'package:pet_route_mobile/models/document_type.dart';

class User {
  String firstName = "";
  String lastName = "";
  DocumentType documentType = DocumentType(id: 0, description: "");
  String document = "";
  String address = "";
  String imageId = "";
  String imageFullPath = "";
  int userType = 0;
  int LogerType = 0;
  String fullName = "";
  //List<> pet;
  //int petCount;
  String id = "";
  String userName = "";
  String normalizedUserName = "";
  String email = "";
  String phoneNumber = "";

  User({
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.document,
    required this.address,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.LogerType,
    required this.fullName,
    //required this.pet,
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    documentType = DocumentType.fromJson(json['documentType']);
    document = json['document'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    LogerType = json['logerType'];
    fullName = json['fullName'];
    //pet = json['pet'];
    //petCount = json['petCount'];
    id = json['id'];
    userName = json['userName'];
    normalizedUserName = json['normalizedUserName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    if (this.documentType != null) {
      data['documentType'] = this.documentType.toJson();
    }
    data['document'] = this.document;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['logerType'] = this.LogerType;
    data['fullName'] = this.fullName;
    //data['pet'] = this.pet;
    //data['petCount'] = this.petCount;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['normalizedUserName'] = this.normalizedUserName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
