import 'package:flutter/material.dart';
import '../models/package_detail.dart';

class GeneralServicesDetailsScreen extends StatelessWidget {
  final PackageDetail packageDetail;

  const GeneralServicesDetailsScreen({Key? key, required this.packageDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black54 : Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📦 نام پکیج
              Text(
                packageDetail.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 🔢 کد پکیج
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'کد:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    packageDetail.code,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 📝 توضیحات
              Text(
                packageDetail.description ?? 'اطلاعات بیشتری موجود نیست.',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 🔘 دکمه بستن
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                label: Text(
                  'بستن',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.indigo.shade700 : Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
