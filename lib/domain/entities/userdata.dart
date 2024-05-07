
class UserData{
  final String email;
  final String uid;
  final String userName;
  final String userType;

  UserData({
   required this.email, 
   required this.uid, 
   required this.userName,
   required this.userType
  });

  Map<String, dynamic> toJson() => {
    "username": userName,
    "uid": uid,
    "email": email,
    "userType": userType,
  };

}