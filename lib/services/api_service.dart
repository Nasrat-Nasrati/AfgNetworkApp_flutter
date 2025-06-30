import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../models/operator.dart';
// import '../models/service_package.dart';
// import '../models/package.dart';
// import '../models/package_detail.dart';
//

import 'package:first_mobile_app_afg_network/models/operator.dart';
import 'package:first_mobile_app_afg_network/models/package.dart';
import 'package:first_mobile_app_afg_network/models/package_detail.dart';
import 'package:first_mobile_app_afg_network/models/service_package.dart';


class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<Operator>> fetchAllOperators() async {
    final uri = Uri.parse('$baseUrl/operators/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => Operator.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت اپراتورها');
    }
  }

  Future<Operator> fetchOperator(int id) async {
    final uri = Uri.parse('$baseUrl/operators/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Operator.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('خطا در دریافت اپراتور');
    }
  }

  Future<List<ServicePackage>> fetchServicePackagesByOperator(int operatorId) async {
    final uri = Uri.parse('$baseUrl/service-packages/?operator=$operatorId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => ServicePackage.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت سرویس‌های اپراتور');
    }
  }

  Future<ServicePackage> fetchServicePackage(int id) async {
    final uri = Uri.parse('$baseUrl/service-packages/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ServicePackage.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('خطا در دریافت سرویس');
    }
  }

  Future<List<Package>> fetchPackagesByServicePackage(int servicePackageId) async {
    final uri = Uri.parse('$baseUrl/packages/?service_package=$servicePackageId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => Package.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت پکیج‌ها');
    }
  }

  Future<Package> fetchPackage(int id) async {
    final uri = Uri.parse('$baseUrl/packages/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Package.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('خطا در دریافت پکیج');
    }
  }

  Future<PackageDetail> fetchPackageDetail(int id) async {
    final uri = Uri.parse('$baseUrl/package-details/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return PackageDetail.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('خطا در دریافت جزییات پکیج');
    }
  }

  Future<List<PackageDetail>> fetchPackageDetailsByPackage(int packageId) async {
    final uri = Uri.parse('$baseUrl/package-details/?package=$packageId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => PackageDetail.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت جزییات پکیج‌ها');
    }
  }
}

