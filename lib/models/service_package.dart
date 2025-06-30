import 'operator.dart';

class ServicePackage {
  final int id;
  final String name;
  final bool isServices; // 🔹 فیلد جدید برای بررسی نوع سرویس
  final Operator operator; // 🔹 شیء تو در تو از نوع اپراتور

  ServicePackage({
    required this.id,
    required this.name,
    required this.isServices,
    required this.operator,
  });

  // ✅ Getter برای گرفتن فقط آیدی اپراتور
  int get operatorId => operator.id;

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['id'],
      name: json['name'],
      isServices: json['is_services'],
      operator: Operator.fromJson(json['operator']),
    );
  }
}

