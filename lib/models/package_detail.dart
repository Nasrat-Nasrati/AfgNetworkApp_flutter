import 'package.dart';

class PackageDetail {
  final int id;
  final Package package;         // Nested Package object
  final String name;
  final double price;
  final String activationCode;
  final String deactivationCode;
  final String checkBalanceCode;

  PackageDetail({
    required this.id,
    required this.package,
    required this.name,
    required this.price,
    required this.activationCode,
    required this.deactivationCode,
    required this.checkBalanceCode,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id'],
      package: Package.fromJson(json['package']),
      name: json['name'],
      price: _parseDouble(json['price']),
      activationCode: json['activation_code'],
      deactivationCode: json['deactivation_code'],
      checkBalanceCode: json['check_balance_code'],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
