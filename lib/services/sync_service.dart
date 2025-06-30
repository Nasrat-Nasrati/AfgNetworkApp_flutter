//
// import 'api_service.dart';
// import '../database/db_helper.dart';
// import '../models/operator.dart';
// import '../models/package.dart';
// import '../models/package_detail.dart';
// import '../models/service_package.dart';

// در sync_service.dart و api_service.dart
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
    for (var operator in operators) {
      await dbHelper.insertOperator(operator);

      // سرویس‌های اپراتور
      List<ServicePackage> servicePackages = await apiService.fetchServicePackagesByOperator(operator.id);
      for (var servicePackage in servicePackages) {
        await dbHelper.insertServicePackage(servicePackage);

        // پکیج‌های سرویس
        List<Package> packages = await apiService.fetchPackagesByServicePackage(servicePackage.id);
        for (var package in packages) {
          await dbHelper.insertPackage(package);

          // جزییات پکیج
          List<PackageDetail> details = await apiService.fetchPackageDetailsByPackage(package.id);
          for (var detail in details) {
            await dbHelper.insertPackageDetail(detail);
          }
        }
      }
    }
  }
}
