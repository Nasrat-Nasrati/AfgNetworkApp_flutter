import 'package:flutter/material.dart';
import '../models/service_package.dart';
import '../models/operator.dart';
import '../services/api_service.dart';
import 'general_service_screen.dart';
import 'packages_screen.dart';
import '../generated/l10n.dart'; // اضافه برای ترجمه

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

  Icon _getIconForPackageName(String name, bool isDarkMode) {
    final lowerName = name.toLowerCase();
    Color iconColor;
    if (lowerName.contains('internet') || lowerName.contains('اینترنت')) {
      iconColor = isDarkMode ? Colors.blue[300]! : Colors.blue;
      return Icon(Icons.wifi, color: iconColor);
    } else if (lowerName.contains('call') || lowerName.contains('تماس')) {
      iconColor = isDarkMode ? Colors.green[300]! : Colors.green;
      return Icon(Icons.call, color: iconColor);
    } else if (lowerName.contains('message') || lowerName.contains('پیام')) {
      iconColor = isDarkMode ? Colors.orange[300]! : Colors.orange;
      return Icon(Icons.message, color: iconColor);
    } else if (lowerName.contains('sms')) {
      iconColor = isDarkMode ? Colors.orange[300]! : Colors.orange;
      return Icon(Icons.sms, color: iconColor);
    } else if (lowerName.contains('data')) {
      iconColor = isDarkMode ? Colors.purple[300]! : Colors.purple;
      return Icon(Icons.data_usage, color: iconColor);
    } else if (lowerName.contains('video')) {
      iconColor = isDarkMode ? Colors.red[300]! : Colors.red;
      return Icon(Icons.videocam, color: iconColor);
    } else if (lowerName.contains('services') || lowerName.contains('خدمات')) {
      iconColor = isDarkMode ? Colors.red[200]! : Colors.red;
      return Icon(Icons.miscellaneous_services, color: iconColor);
    } else {
      iconColor = isDarkMode ? Colors.grey[400]! : Colors.grey;
      return Icon(Icons.local_offer, color: iconColor);
    }
  }

  Color _getBackgroundColorForPackageName(String name, ThemeData theme) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('internet') || lowerName.contains('اینترنت')) {
      return theme.brightness == Brightness.light
          ? Colors.blue.shade50
          : Colors.blue.shade900.withOpacity(0.3);
    } else if (lowerName.contains('call') || lowerName.contains('تماس')) {
      return theme.brightness == Brightness.light
          ? Colors.green.shade50
          : Colors.green.shade900.withOpacity(0.3);
    } else if (lowerName.contains('message') || lowerName.contains('پیام') || lowerName.contains('sms')) {
      return theme.brightness == Brightness.light
          ? Colors.orange.shade50
          : Colors.orange.shade900.withOpacity(0.3);
    } else if (lowerName.contains('data')) {
      return theme.brightness == Brightness.light
          ? Colors.purple.shade50
          : Colors.purple.shade900.withOpacity(0.3);
    } else if (lowerName.contains('video')) {
      return theme.brightness == Brightness.light
          ? Colors.red.shade50
          : Colors.red.shade900.withOpacity(0.3);
    } else if (lowerName.contains('services') || lowerName.contains('خدمات')) {
      return theme.brightness == Brightness.light
          ? Colors.red.shade100
          : Colors.red.shade900.withOpacity(0.4);
    } else {
      return theme.cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).servicesTitle(widget.operator.name)), // ✅ ترجمه
        centerTitle: true,
      ),
      body: FutureBuilder<List<ServicePackage>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(S.of(context).errorFetchingServices(snapshot.error.toString())), // ✅ ترجمه
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noServicesFoundForOperator)); // ✅ ترجمه
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
                  color: _getBackgroundColorForPackageName(package.name, theme),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black54 : Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: _getIconForPackageName(package.name, isDarkMode),
                  title: Text(
                    package.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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


