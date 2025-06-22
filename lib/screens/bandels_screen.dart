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

  Widget buildCodeField(String label, String code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.code, color: Colors.indigo),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                    text: code,
                    style: const TextStyle(fontWeight: FontWeight.normal),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          ' Bundles - ${widget.package.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<PackageDetail>>(
        future: futurePackageDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('🚫 No bundles found.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          final bundleList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bundleList.length,
            itemBuilder: (context, index) {
              final bundle = bundleList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for Name and Price
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bundle Name
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                bundle.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.indigo,

                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              ' ${bundle.price} AFN',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Code Fields
                    buildCodeField("Activation", bundle.activationCode),
                    buildCodeField("Deactivation", bundle.deactivationCode),
                    buildCodeField("Check Balance", bundle.checkBalanceCode),
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

