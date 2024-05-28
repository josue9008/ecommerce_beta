class Campaign {
  final String id; // Añadir identificador único
  final String campaignName;
  final int duration;
  final int pointsQuantity;
  final String specialsConditions;

  Campaign({
    required this.id,
    required this.campaignName,
    required this.duration,
    required this.pointsQuantity,
    required this.specialsConditions,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'], // Leer identificador único
      campaignName: json['campaignName'] ?? '',
      duration: json['duration'] ?? 0,
      pointsQuantity: json['pointsQuantity'] ?? 0,
      specialsConditions: json['specialsConditions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id, // Incluir identificador único
    "campaignName": campaignName,
    "duration": duration,
    "pointsQuantity": pointsQuantity,
    "specialsConditions": specialsConditions,
  };
}