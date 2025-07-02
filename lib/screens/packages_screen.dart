


import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/package.dart';
import '../models/service_package.dart';
import '../services/api_service.dart';
import '../database/db_helper.dart';
import 'bandels_screen.dart'; // فرض بر اینکه این صفحه وجود دارد و باید import شود

class PackagesScreen extends StatefulWidget {
  final ServicePackage servicePackage;

  const PackagesScreen({Key? key, required this.servicePackage}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late Future<List<Package>> futurePackages;
  final ApiService apiService = ApiService();
  final dbHelper = DatabaseHelper();
  final connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    // مقدار اولیه دادن برای جلوگیری از خطای LateInitializationError
    futurePackages = Future.value([]);
    _checkAndLoadPackages();
  }

  Future<void> _checkAndLoadPackages() async {
    final localPackages = await dbHelper.getPackages(widget.servicePackage.id);

    if (localPackages.isEmpty) {
      var connection = await connectivity.checkConnectivity();
      if (connection != ConnectivityResult.none) {
        final apiPackages = await apiService.fetchPackagesByServicePackage(widget.servicePackage.id);

        for (var pkg in apiPackages) {
          await dbHelper.insertPackage(pkg);
        }

        setState(() {
          futurePackages = dbHelper.getPackages(widget.servicePackage.id);
        });
      } else {
        setState(() {
          futurePackages = Future.value([]);
        });
        print("❌ هیچ پکیجی یافت نشد و اینترنت قطع است.");
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            'پکیج‌های ${widget.servicePackage.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.indigo.shade700 : Colors.indigo,
          elevation: 4,
        ),
        body: FutureBuilder<List<Package>>(
          future: futurePackages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '❌ خطا در دریافت پکیج‌ها: ${snapshot.error}',
                  style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'هیچ پکیجی یافت نشد.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              );
            }

            final packages = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black54 : Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: isDarkMode ? Colors.indigo.shade300 : Colors.indigo.shade100,
                      child: Icon(Icons.card_giftcard,
                          color: isDarkMode ? Colors.indigo.shade900 : Colors.indigo),
                    ),
                    title: Text(
                      package.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BundlesScreen(package: package),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
