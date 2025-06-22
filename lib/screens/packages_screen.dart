

// lib/screens/packages_screen.dart
import 'package:flutter/material.dart';
import '../models/package.dart';
import '../models/service_package.dart';
import '../services/api_service.dart';
import 'bandels_screen.dart';

class PackagesScreen extends StatefulWidget {
  final ServicePackage servicePackage;

  const PackagesScreen({Key? key, required this.servicePackage}) : super(key: key);

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late Future<List<Package>> futurePackages;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePackages = apiService.fetchPackagesByServicePackage(widget.servicePackage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          '📦 Packages - ${widget.servicePackage.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Package>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '🚫 No packages found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final packages = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.card_giftcard, color: Colors.indigo),
                  ),
                  title: Text(
                    package.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
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
    );
  }
}
