// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import '../models/package.dart';
// import '../models/package_detail.dart';
// import '../services/api_service.dart';
// import '../database/db_helper.dart';
//
// class BundlesScreen extends StatefulWidget {
//   final Package package;
//
//   const BundlesScreen({Key? key, required this.package}) : super(key: key);
//
//   @override
//   _BundlesScreenState createState() => _BundlesScreenState();
// }
//
// class _BundlesScreenState extends State<BundlesScreen> {
//   late Future<List<PackageDetail>> futureDetails;
//   final ApiService apiService = ApiService();
//   final dbHelper = DatabaseHelper();
//   final connectivity = Connectivity();
//
//   @override
//   void initState() {
//     super.initState();
//     _checkAndLoadDetails();
//   }
//
//   Future<void> _checkAndLoadDetails() async {
//     final localDetails = await dbHelper.getPackageDetails(widget.package.id);
//
//     if (localDetails.isEmpty) {
//       var connection = await connectivity.checkConnectivity();
//       if (connection != ConnectivityResult.none) {
//         final apiDetails = await apiService.fetchPackageDetailsByPackage(widget.package.id);
//
//         for (var detail in apiDetails) {
//           await dbHelper.insertPackageDetail(detail);
//         }
//
//         futureDetails = dbHelper.getPackageDetails(widget.package.id);
//       } else {
//         futureDetails = Future.value([]);
//         print("❌ نه دیتا در دیتابیس موجود است و نه اینترنت وصل است.");
//       }
//     } else {
//       futureDetails = Future.value(localDetails);
//     }
//
//     setState(() {});
//   }
//
//   void dialCode(String code) async {
//     if (code.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("کد موجود نیست")),
//       );
//       return;
//     }
//
//     String encoded = code.replaceAll("#", Uri.encodeComponent("#"));
//     String telUrl = "tel:$encoded";
//
//     if (await canLaunch(telUrl)) {
//       await launch(telUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("امکان شماره‌گیری وجود ندارد")),
//       );
//     }
//   }
//
//   Widget buildCodeField(String label, String code, bool isDarkMode) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.grey.shade800 : const Color(0xFFF1F3F5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.code, color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black87,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   code,
//                   style: TextStyle(
//                     fontWeight: FontWeight.normal,
//                     color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//                     fontSize: 15,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildColoredButton(String text, Color color, VoidCallback onPressed) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: ElevatedButton(
//           onPressed: onPressed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           child: Text(
//             text,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(
//           'باندل‌ها - ${widget.package.name}',
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: isDarkMode ? Colors.indigo.shade700 : Colors.indigo,
//         elevation: 4,
//       ),
//       body: FutureBuilder<List<PackageDetail>>(
//         future: futureDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 '❌ خطا در دریافت اطلاعات: ${snapshot.error}',
//                 style: TextStyle(color: Colors.red.shade400, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 '🚫 باندلی یافت نشد.',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
//                 ),
//               ),
//             );
//           }
//
//           final bundleList = snapshot.data!;
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             itemCount: bundleList.length,
//             itemBuilder: (context, index) {
//               final bundle = bundleList[index];
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 14),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: isDarkMode ? Colors.grey.shade900 : Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: isDarkMode ? Colors.black54 : Colors.black12,
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // نام و قیمت
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 14),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: isDarkMode ? Colors.indigo.shade700 : Colors.indigo.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 bundle.name,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 17,
//                                   color: isDarkMode ? Colors.indigo.shade100 : Colors.indigo,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                             decoration: BoxDecoration(
//                               color: isDarkMode ? Colors.green.shade900 : Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isDarkMode ? Colors.green.shade700 : Colors.green.shade200,
//                               ),
//                             ),
//                             child: Text(
//                               '${bundle.price} افغانی',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                                 color: isDarkMode ? Colors.green.shade100 : Colors.green.shade800,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // کدهای فعال سازی، غیرفعال سازی و چک بلانس
//                     buildCodeField('فعال سازی', bundle.activationCode ?? "", isDarkMode),
//                     buildCodeField('غیرفعال سازی', bundle.deactivationCode ?? "", isDarkMode),
//
//                     const SizedBox(height: 12),
//
//                     Row(
//                       children: [
//                         buildColoredButton('فعال سازی', Colors.green, () {
//                           dialCode(bundle.activationCode ?? "");
//                         }),
//                         buildColoredButton('غیرفعال سازی', Colors.red, () {
//                           dialCode(bundle.deactivationCode ?? "");
//                         }),
//                         buildColoredButton('چک بلانس', Colors.orange, () {
//                           dialCode(bundle.checkBalanceCode ?? "");
//                         }),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/package.dart';
import '../models/package_detail.dart';
import '../services/api_service.dart';
import '../database/db_helper.dart';

class BundlesScreen extends StatefulWidget {
  final Package package;

  const BundlesScreen({Key? key, required this.package}) : super(key: key);

  @override
  _BundlesScreenState createState() => _BundlesScreenState();
}

class _BundlesScreenState extends State<BundlesScreen> {
  late Future<List<PackageDetail>> futureDetails;
  final ApiService apiService = ApiService();
  final dbHelper = DatabaseHelper();
  final connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    // مقدار اولیه بدون دیتا (لیست خالی) تا FutureBuilder خطا ندهد
    futureDetails = Future.value([]);
    // سپس داده‌ها را بارگذاری می‌کنیم
    _checkAndLoadDetails();
  }

  Future<void> _checkAndLoadDetails() async {
    final localDetails = await dbHelper.getPackageDetails(widget.package.id);

    if (localDetails.isEmpty) {
      var connection = await connectivity.checkConnectivity();
      if (connection != ConnectivityResult.none) {
        final apiDetails = await apiService.fetchPackageDetailsByPackage(widget.package.id);

        for (var detail in apiDetails) {
          await dbHelper.insertPackageDetail(detail);
        }

        setState(() {
          futureDetails = dbHelper.getPackageDetails(widget.package.id);
        });
      } else {
        setState(() {
          futureDetails = Future.value([]);
        });
        print("❌ نه دیتا در دیتابیس موجود است و نه اینترنت وصل است.");
      }
    } else {
      setState(() {
        futureDetails = Future.value(localDetails);
      });
    }
  }

  void dialCode(String code) async {
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("کد موجود نیست")),
      );
      return;
    }

    String encoded = code.replaceAll("#", Uri.encodeComponent("#"));
    String telUrl = "tel:$encoded";

    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("امکان شماره‌گیری وجود ندارد")),
      );
    }
  }

  Widget buildCodeField(String label, String code, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.code, color: isDarkMode ? Colors.indigo.shade200 : Colors.indigo),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColoredButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
          'باندل‌ها - ${widget.package.name}',
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
        future: futureDetails,
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
                '❌ خطا در دریافت اطلاعات: ${snapshot.error}',
                style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '🚫 باندلی یافت نشد.',
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
                    // نام و قیمت
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              '${bundle.price} افغانی',
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

                    // کدهای فعال سازی، غیرفعال سازی و چک بلانس
                    buildCodeField('فعال سازی', bundle.activationCode ?? "", isDarkMode),
                    buildCodeField('غیرفعال سازی', bundle.deactivationCode ?? "", isDarkMode),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        buildColoredButton('فعال سازی', Colors.green, () {
                          dialCode(bundle.activationCode ?? "");
                        }),
                        buildColoredButton('غیرفعال سازی', Colors.red, () {
                          dialCode(bundle.deactivationCode ?? "");
                        }),
                        buildColoredButton('چک بلانس', Colors.orange, () {
                          dialCode(bundle.checkBalanceCode ?? "");
                        }),
                      ],
                    ),
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
