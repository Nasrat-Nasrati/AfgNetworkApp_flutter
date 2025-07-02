
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/service_package.dart';
import '../models/package.dart';
import '../models/package_detail.dart';
import '../services/api_service.dart';
import '../database/db_helper.dart';
import 'general_services_details.dart';

class GeneralServiceScreen extends StatefulWidget {
  final ServicePackage servicePackage;

  const GeneralServiceScreen({Key? key, required this.servicePackage}) : super(key: key);

  @override
  State<GeneralServiceScreen> createState() => _GeneralServiceScreenState();
}

class _GeneralServiceScreenState extends State<GeneralServiceScreen> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();
  final connectivity = Connectivity();

  // مقداردهی اولیه با Future.value([]) تا ارور LateInitializationError رفع شود
  late Future<List<Package>> futurePackages = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final localPackages = await dbHelper.getPackages(widget.servicePackage.id);

    if (localPackages.isEmpty) {
      var connection = await connectivity.checkConnectivity();
      if (connection != ConnectivityResult.none) {
        final fetched = await apiService.fetchPackagesByServicePackage(widget.servicePackage.id);
        for (var item in fetched) {
          await dbHelper.insertPackage(item);
        }
        setState(() {
          futurePackages = dbHelper.getPackages(widget.servicePackage.id);
        });
      } else {
        setState(() {
          futurePackages = Future.value([]);
        });
        print("📴 اینترنت قطع است و دیتایی موجود نیست.");
      }
    } else {
      setState(() {
        futurePackages = Future.value(localPackages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'خدمات ${widget.servicePackage.operator.name}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.indigo.shade700 : Colors.indigo,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Package>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ خطا در دریافت داده: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '🚫 هیچ پکیجی یافت نشد.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            );
          }

          final packages = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: Center(child: CircularProgressIndicator()),
                    ),
                  );

                  try {
                    final details = await dbHelper.getPackageDetails(package.id);

                    if (details.isEmpty) {
                      var connection = await connectivity.checkConnectivity();
                      if (connection != ConnectivityResult.none) {
                        final fetched = await apiService.fetchPackageDetailsByPackage(package.id);
                        for (var item in fetched) {
                          await dbHelper.insertPackageDetail(item);
                        }

                        Navigator.of(context).pop();

                        if (fetched.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('❌ جزئیاتی یافت نشد.')),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GeneralServicesDetailsScreen(packageDetail: fetched[0]),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📴 اینترنت قطع است و دیتایی موجود نیست.')),
                        );
                      }
                    } else {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GeneralServicesDetailsScreen(packageDetail: details[0]),
                        ),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطا در دریافت جزئیات: $e')),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode
                              ? Colors.indigo.shade700.withOpacity(0.4)
                              : Colors.indigo.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.card_giftcard,
                          size: 30,
                          color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        package.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
