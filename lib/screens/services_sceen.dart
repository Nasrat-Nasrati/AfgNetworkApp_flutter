import 'package:flutter/material.dart';
import '../models/service_package.dart';
import '../models/operator.dart';
import '../services/api_service.dart';
import 'general_service_screen.dart';

import 'packages_screen.dart';

class ServicesScreen extends StatefulWidget {
  final Operator operator;

  const ServicesScreen({Key? key, required this.operator}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late Future<List<ServicePackage>> futurePackages;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePackages = apiService.fetchServicePackagesByOperator(widget.operator.id);
  }

  Icon _getIconForPackageName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('internet') || lowerName.contains('اینترنت')) {
      return Icon(Icons.wifi, color: Colors.blue);
    } else if (lowerName.contains('call') || lowerName.contains('تماس')) {
      return Icon(Icons.call, color: Colors.green);
    } else if (lowerName.contains('message') || lowerName.contains('پیام')) {
      return Icon(Icons.message, color: Colors.orange);
    } else if (lowerName.contains('sms')) {
      return Icon(Icons.sms, color: Colors.orange);
    } else if (lowerName.contains('data')) {
      return Icon(Icons.data_usage, color: Colors.purple);
    } else if (lowerName.contains('video')) {
      return Icon(Icons.videocam, color: Colors.red);
    } else if (lowerName.contains('services') || lowerName.contains('خدمات')) {
      return Icon(Icons.miscellaneous_services, color: Colors.red);
    } else {
      return Icon(Icons.local_offer, color: Colors.grey);
    }
  }

  Color _getBackgroundColorForPackageName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('internet') || lowerName.contains('اینترنت')) {
      return Colors.blue.shade50;
    } else if (lowerName.contains('call') || lowerName.contains('تماس')) {
      return Colors.green.shade50;
    } else if (lowerName.contains('message') || lowerName.contains('پیام') || lowerName.contains('sms')) {
      return Colors.orange.shade50;
    } else if (lowerName.contains('data')) {
      return Colors.purple.shade50;
    } else if (lowerName.contains('video')) {
      return Colors.red.shade50;
    } else if (lowerName.contains('services') || lowerName.contains('خدمات')) {
      return Colors.red.shade100;
    } else {
      return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services - ${widget.operator.name}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ServicePackage>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services found for this operator.'));
          }

          final packages = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: packages.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final package = packages[index];
              return Container(
                decoration: BoxDecoration(
                  color: _getBackgroundColorForPackageName(package.name),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: _getIconForPackageName(package.name),
                  title: Text(
                    package.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    if (package.isServices) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeneralServiceScreen(servicePackage: package),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackagesScreen(servicePackage: package),
                        ),
                      );
                    }
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



