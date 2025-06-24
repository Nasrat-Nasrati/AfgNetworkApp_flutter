import 'package:flutter/material.dart';
import '../models/package_detail.dart';

class GeneralServicesDetailsScreen extends StatelessWidget {
  final PackageDetail packageDetail;

  const GeneralServicesDetailsScreen({Key? key, required this.packageDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3), // پس‌زمینه تاریک مانند دیالوگ
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📦 نام بسته
              Text(
                packageDetail.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 🔢 کد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Code:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    packageDetail.code,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 📝 توضیحات
              Text(
                packageDetail.description ?? 'توضیحی در دسترس نیست.',
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // 🔘 دکمه بستن
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text("Close"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
