class Operator {
  final int id;
  final String name;
  final String logo;       // URL as String
  final String description;

  Operator({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json['id'],
      name: json['name'],
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
