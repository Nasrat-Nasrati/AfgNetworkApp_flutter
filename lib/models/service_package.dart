import 'operator.dart';

class ServicePackage {
  final int id;
  final String name;
  final Operator operator;   // Nested Operator object

  ServicePackage({
    required this.id,
    required this.name,
    required this.operator,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['id'],
      name: json['name'],
      operator: Operator.fromJson(json['operator']),
    );
  }
}
