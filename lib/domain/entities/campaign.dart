class Campaign {
  final String id;
  final String campaignName;
  final int duration;
  final int pointsQuantity;  

  Campaign({
    required this.id,
    required this.campaignName,
    required this.duration,
    required this.pointsQuantity,   
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'], // Leer identificador único
      campaignName: json['campaignName'] ?? '',
      duration: json['duration'] ?? 0,
      pointsQuantity: json['pointsQuantity'] ?? 0,     
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id, // Incluir identificador único
    "campaignName": campaignName,
    "duration": duration,
    "pointsQuantity": pointsQuantity,   
  };
}