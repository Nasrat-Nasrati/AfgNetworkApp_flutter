import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/operator.dart';
import '../models/service_package.dart';
import '../models/package.dart';
import '../models/package_detail.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  // گرفتن لیست تمام اپراتورها
  Future<List<Operator>> fetchAllOperators() async {
    final uri = Uri.parse('$baseUrl/operators/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Operator.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت اپراتورها');
    }
  }

  // گرفتن یک اپراتور خاص با id
  Future<Operator> fetchOperator(int id) async {
    final uri = Uri.parse('$baseUrl/operators/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Operator.fromJson(json.decode(response.body));
    } else {
      throw Exception('خطا در دریافت اپراتور');
    }
  }

  // گرفتن لیست سرویس‌ها برای یک اپراتور خاص
  Future<List<ServicePackage>> fetchServicePackagesByOperator(
      int operatorId) async {
    final uri = Uri.parse('$baseUrl/service-packages/?operator=$operatorId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ServicePackage.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت سرویس‌های اپراتور');
    }
  }

  // گرفتن یک سرویس خاص با id
  Future<ServicePackage> fetchServicePackage(int id) async {
    final uri = Uri.parse('$baseUrl/service-packages/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ServicePackage.fromJson(json.decode(response.body));
    } else {
      throw Exception('خطا در دریافت سرویس');
    }
  }

  // گرفتن لیست پکیج‌ها مربوط به یک سرویس خاص
  Future<List<Package>> fetchPackagesByServicePackage(
      int servicePackageId) async {
    final uri = Uri.parse(
        '$baseUrl/packages/?service_package=$servicePackageId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Package.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت پکیج‌ها');
    }
  }

  // گرفتن یک پکیج خاص با id
  Future<Package> fetchPackage(int id) async {
    final uri = Uri.parse('$baseUrl/packages/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Package.fromJson(json.decode(response.body));
    } else {
      throw Exception('خطا در دریافت پکیج');
    }
  }

  // گرفتن جزییات پکیج خاص با id
  Future<PackageDetail> fetchPackageDetail(int id) async {
    final uri = Uri.parse('$baseUrl/package-details/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return PackageDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('خطا در دریافت جزییات پکیج');
    }
  }

  Future<List<PackageDetail>> fetchPackageDetailsByPackage(
      int packageId) async {
    final uri = Uri.parse('$baseUrl/package-details/?package=$packageId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => PackageDetail.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت جزییات پکیج‌ها');
    }
  }
}