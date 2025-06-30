import 'package.dart';

class PackageDetail {
  final int id;
  final Package package;
  final String name;
  final double? price;
  final String? activationCode;
  final String? deactivationCode;
  final String? checkBalanceCode;
  final String code;
  final String? description;
  final String buttonActive;
  final String buttonDeactive;
  final String buttonCheckBlance;

  PackageDetail({
    required this.id,
    required this.package,
    required this.name,
    this.price,
    this.activationCode,
    this.deactivationCode,
    this.checkBalanceCode,
    required this.code,
    this.description,
    required this.buttonActive,
    required this.buttonDeactive,
    required this.buttonCheckBlance,
  });

  // ✅ Getter برای گرفتن فقط آیدی Package
  int get packageId => package.id;

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id'],
      package: Package.fromJson(json['package']),
      name: json['name'],
      price: _parseDouble(json['price']),
      activationCode: json['activation_code'],
      deactivationCode: json['deactivation_code'],
      checkBalanceCode: json['check_balance_code'],
      code: json['code'],
      description: json['description'],
      buttonActive: json['button_active'] ?? "Active",
      buttonDeactive: json['button_deactive'] ?? "Deactive",
      buttonCheckBlance: json['button_check_blance'] ?? "Check blance",
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value);
    } else {
      return null;
    }
  }
}

