import 'package:flutter/material.dart';
import '../models/service_package.dart';
import '../models/package.dart';
import '../services/api_service.dart';
import '../models/package_detail.dart';
import 'general_services_details.dart';
import '../generated/l10n.dart'; // Import generated localization

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final s = S.of(context); // <-- Localization shortcut

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          '${s.servicesOf} ${widget.servicePackage.operator.name}', // localized
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.indigo.shade700 : Colors.indigo,
        elevation: 4,
        centerTitle: true,
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
                '❌ ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '🚫 ${s.noPackagesFound}', // localized
                style: TextStyle(
                  fontSize: 10,
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
                      content: Center(
                        heightFactor: 1,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );

                  try {
                    List<PackageDetail> details = await apiService.fetchPackageDetailsByPackage(package.id);

                    Navigator.of(context).pop();

                    if (details.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('❌ ${s.noDetailsFound}')),
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
                      SnackBar(content: Text('${s.errorFetchingDetails} $e')),
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
                          color: isDarkMode ? Colors.indigo.shade700.withOpacity(0.4) : Colors.indigo.withOpacity(0.2),
                        ),
                        child: Icon(Icons.card_giftcard, size: 30, color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo),
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

