

import 'package:ecommerce_beta/domain/domain.dart';

class UserMapper{

  static User userJsonToEntity(Map<String, dynamic> json) => User(
    id: json['id'], 
    email: json['email'], 
    fullName: json['fullName'], 
    phoneNumber: json['phoneNumber'], 
    roles: List<String>.from(json['roles'].map((role)=>role)) , 
    token: json['token'],
  );

}