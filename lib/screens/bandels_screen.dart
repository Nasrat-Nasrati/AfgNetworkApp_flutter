

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/package.dart';
import '../models/package_detail.dart';
import '../services/api_service.dart';

class BundlesScreen extends StatefulWidget {
  final Package package;

  const BundlesScreen({Key? key, required this.package}) : super(key: key);

  @override
  _BundlesScreenState createState() => _BundlesScreenState();
}

class _BundlesScreenState extends State<BundlesScreen> {
  late Future<List<PackageDetail>> futurePackageDetails;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePackageDetails = apiService.fetchPackageDetailsByPackage(widget.package.id);
  }

  Widget buildCodeField(String label, String code, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.code, color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: code,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.grey.shade300 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Bundles - ${widget.package.name}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.indigo.shade700 : Colors.indigo,
        elevation: 4,
      ),
      body: FutureBuilder<List<PackageDetail>>(
        future: futurePackageDetails,
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
                style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '🚫 No bundles found.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            );
          }

          final bundleList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: bundleList.length,
            itemBuilder: (context, index) {
              final bundle = bundleList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for Name and Price
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bundle Name
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.indigo.shade700 : Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                bundle.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: isDarkMode ? Colors.indigo.shade100 : Colors.indigo,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.green.shade900 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode ? Colors.green.shade700 : Colors.green.shade200,
                              ),
                            ),
                            child: Text(
                              '${bundle.price} AFN',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: isDarkMode ? Colors.green.shade100 : Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Code Fields
                    buildCodeField("Activation", bundle.activationCode ?? "", isDarkMode),
                    buildCodeField("Deactivation", bundle.deactivationCode ?? "", isDarkMode),
                    buildCodeField("Check Balance", bundle.checkBalanceCode ?? "", isDarkMode),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
