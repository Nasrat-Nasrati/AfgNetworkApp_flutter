


import 'api_service.dart';
import 'package:first_mobile_app_afg_network/database/db_helper.dart';
import 'package:first_mobile_app_afg_network/models/operator.dart';
import 'package:first_mobile_app_afg_network/models/package.dart';
import 'package:first_mobile_app_afg_network/models/package_detail.dart';
import 'package:first_mobile_app_afg_network/models/service_package.dart';

class SyncService {
  final apiService = ApiService();
  final dbHelper = DatabaseHelper();

  Future<void> syncAllData() async {
    // اپراتورها
    List<Operator> operators = await apiService.fetchAllOperators();
    print('📡 تعداد اپراتورهای دریافت‌شده از API: ${operators.length}');

    for (var operator in operators) {
      await dbHelper.insertOperator(operator);
      print('✅ اپراتور ذخیره شد: ${operator.name}');

      // سرویس‌های اپراتور
      List<ServicePackage> servicePackages =
      await apiService.fetchServicePackagesByOperator(operator.id);
      print('🔸 ${servicePackages.length} سرویس برای اپراتور ${operator.name} دریافت شد');

      for (var servicePackage in servicePackages) {
        await dbHelper.insertServicePackage(servicePackage);
        print('📦 سرویس ذخیره شد: ${servicePackage.name}');

        // پکیج‌های سرویس
        List<Package> packages =
        await apiService.fetchPackagesByServicePackage(servicePackage.id);
        print('🔹 ${packages.length} پکیج دریافت شد برای سرویس ${servicePackage.name}');

        for (var package in packages) {
          await dbHelper.insertPackage(package);
          print('📤 پکیج ذخیره شد: ${package.name}');

          // جزییات پکیج
          List<PackageDetail> details =
          await apiService.fetchPackageDetailsByPackage(package.id);
          print('📘 ${details.length} جزییات دریافت شد برای پکیج ${package.name}');

          for (var detail in details) {
            await dbHelper.insertPackageDetail(detail);
            print('📝 جزییات ذخیره شد: ${detail.name}');
          }
        }
      }
    }

    // ✅ بررسی نهایی: خواندن از دیتابیس برای اطمینان
    final savedOperators = await dbHelper.getOperators();
    print('🟢 تعداد اپراتورهای ذخیره‌شده در دیتابیس محلی: ${savedOperators.length}');
    for (var op in savedOperators) {
      print('🔍 اپراتور موجود در دیتابیس: ${op.name}');
    }
  }
}
