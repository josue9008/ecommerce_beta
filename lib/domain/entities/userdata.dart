import '../domain.dart';
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

class CommerceData {
  final String email;
  final String uid;
  final String userName;
  final String userType;
  final List<UserPoints> userPointsList;
  final List<Campaign> campaigns; // Nueva lista de campañas

  CommerceData({
    required this.email,
    required this.uid,
    required this.userName,
    required this.userType,
    required this.userPointsList,
    required this.campaigns,
  });

  factory CommerceData.fromJson(Map<String, dynamic> json) {
    return CommerceData(
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
      userName: json['username'] ?? '',
      userType: json['userType'] ?? '',
      userPointsList: (json['userPointsList'] as List?)
              ?.map((pointData) => UserPoints.fromJson(pointData))
              .toList() ??
          [],
      campaigns: (json['campaigns'] as List?)
              ?.map((campaignData) => Campaign.fromJson(campaignData))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": userName,
        "uid": uid,
        "email": email,
        "userType": userType,
        "userPointsList": userPointsList.map((up) => up.toJson()).toList(),
        "campaigns": campaigns.map((c) => c.toJson()).toList(),
      };
}

class UserPoints {
  final String userUid;
  final String campaignName;
  int awardedPoints;

  UserPoints({
    required this.userUid,
    required this.campaignName,
    required this.awardedPoints,
  });

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      userUid: json['userUid'] ?? '',
      campaignName: json['campaignName'] ?? '',
      awardedPoints: json['awardedPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "userUid": userUid,
     "campaignName": campaignName,
    "awardedPoints": awardedPoints,
  };
}