import 'service_package.dart';

class Package {
  final int id;
  final String name;
  final ServicePackage servicePackage; // 🔹 شیء تو در تو از نوع ServicePackage

  Package({
    required this.id,
    required this.name,
    required this.servicePackage,
  });

  // ✅ Getter برای گرفتن فقط آیدی ServicePackage
  int get servicePackageId => servicePackage.id;

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      servicePackage: ServicePackage.fromJson(json['service_package']),
    );
  }
}

