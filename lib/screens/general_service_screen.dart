import 'package:flutter/material.dart';
import '../models/service_package.dart';
import '../models/package.dart';
import '../services/api_service.dart';
import '../models/package_detail.dart';
import 'general_services_details.dart';
import 'bandels_screen.dart';

class GeneralServiceScreen extends StatefulWidget {
  final ServicePackage servicePackage;

  const GeneralServiceScreen({Key? key, required this.servicePackage}) : super(key: key);

  @override
  State<GeneralServiceScreen> createState() => _GeneralServiceScreenState();
}

class _GeneralServiceScreenState extends State<GeneralServiceScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Package>> futurePackages;

  @override
  void initState() {
    super.initState();
    futurePackages = apiService.fetchPackagesByServicePackage(widget.servicePackage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services of ${widget.servicePackage.operator.name}'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Package>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('🚫 هیچ پکیجی یافت نشد.'));
          }

          final packages = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    List<PackageDetail> details = await apiService.fetchPackageDetailsByPackage(package.id);

                    Navigator.of(context).pop();

                    if (details.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('❌ هیچ جزییاتی برای این پکیج یافت نشد')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneralServicesDetailsScreen(
                          packageDetail: details[0],
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطا در دریافت جزییات پکیج: $e')),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo.withOpacity(0.2),
                        ),
                        child: const Icon(Icons.card_giftcard, size: 28, color: Colors.indigo),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
