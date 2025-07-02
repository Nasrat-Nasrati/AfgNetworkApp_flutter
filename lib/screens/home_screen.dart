//
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import '../database/db_helper.dart';
// import '../models/operator.dart';
// import '../services/sync_service.dart';
// import 'services_sceen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final void Function() toggleTheme;
//   final bool isDarkMode;
//
//   const HomeScreen({
//     Key? key,
//     required this.toggleTheme,
//     required this.isDarkMode,
//   }) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final dbHelper = DatabaseHelper();
//   final syncService = SyncService();
//   late Future<List<Operator>> futureOperators;
//
//   final List<String> imagePaths = [
//     'assets/images/1.png',
//     'assets/images/2.png',
//     'assets/images/3.png',
//     'assets/images/4.png',
//   ];
//
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     futureOperators = _checkAndSyncData();
//     Future.delayed(const Duration(seconds: 3), _autoSlide);
//   }
//
//   void _autoSlide() {
//     if (!_pageController.hasClients) return;
//
//     int nextPage = (_currentPage + 1) % imagePaths.length;
//     _pageController.animateToPage(
//       nextPage,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInOut,
//     );
//
//     _currentPage = nextPage;
//     Future.delayed(const Duration(seconds: 3), _autoSlide);
//   }
//
//   Future<List<Operator>> _checkAndSyncData() async {
//     final localOperators = await dbHelper.getOperators();
//
//     if (localOperators.isEmpty) {
//       var connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult != ConnectivityResult.none) {
//         await syncService.syncAllData();
//         return await dbHelper.getOperators();
//       } else {
//         print("❌ دیتایی یافت نشد و اینترنت هم وصل نیست.");
//         return [];
//       }
//     } else {
//       return localOperators;
//     }
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//           foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
//           title: const Text('شبکه افغانستان'),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               tooltip: widget.isDarkMode ? 'حالت روشن' : 'حالت تاریک',
//               icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//               onPressed: widget.toggleTheme,
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<Operator>>(
//           future: futureOperators,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('❌ خطا: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('اپراتوری یافت نشد'));
//             }
//
//             final operators = snapshot.data!;
//
//             return Column(
//               children: [
//                 // اسلایدشو با ارتفاع 35% صفحه
//                 SizedBox(
//                   height: screenHeight * 0.35,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: imagePaths.length,
//                           onPageChanged: (index) {
//                             setState(() {
//                               _currentPage = index;
//                             });
//                           },
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Image.asset(
//                                   imagePaths[index],
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, bottom: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(imagePaths.length, (index) {
//                             return AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               margin: const EdgeInsets.symmetric(horizontal: 6),
//                               width: _currentPage == index ? 14 : 10,
//                               height: _currentPage == index ? 14 : 10,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: _currentPage == index
//                                     ? Theme.of(context).colorScheme.primary
//                                     : Colors.grey.shade400,
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // لیست اپراتورها
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, -3),
//                         ),
//                       ],
//                     ),
//                     child: GridView.builder(
//                       itemCount: operators.length,
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                         childAspectRatio: 0.85,
//                       ),
//                       itemBuilder: (context, index) {
//                         final operator = operators[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ServicesScreen(operator: operator),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             color: Theme.of(context).colorScheme.surface,
//                             shadowColor: Colors.black45,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.network(
//                                     operator.logo,
//                                     height: 60,
//                                     fit: BoxFit.contain,
//                                   ),
//                                   const SizedBox(height: 14),
//                                   Text(
//                                     operator.name,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 16,
//                                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }





import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../database/db_helper.dart';
import '../models/operator.dart';
import '../services/sync_service.dart';
import '../utils/image_helper.dart'; // ✅ اضافه شد
import 'services_sceen.dart';

class HomeScreen extends StatefulWidget {
  final void Function() toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  final syncService = SyncService();
  late Future<List<Operator>> futureOperators;

  final List<String> imagePaths = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    futureOperators = _checkAndSyncData();
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!_pageController.hasClients) return;

    int nextPage = (_currentPage + 1) % imagePaths.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _currentPage = nextPage;
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  Future<List<Operator>> _checkAndSyncData() async {
    final localOperators = await dbHelper.getOperators();

    if (localOperators.isEmpty) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await syncService.syncAllData();
        return await dbHelper.getOperators();
      } else {
        print("❌ دیتایی یافت نشد و اینترنت هم وصل نیست.");
        return [];
      }
    } else {
      return localOperators;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title: const Text('شبکه افغانستان'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: widget.isDarkMode ? 'حالت روشن' : 'حالت تاریک',
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: FutureBuilder<List<Operator>>(
          future: futureOperators,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('❌ خطا: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('اپراتوری یافت نشد'));
            }

            final operators = snapshot.data!;

            return Column(
              children: [
                // اسلایدشو با ارتفاع 35% صفحه
                SizedBox(
                  height: screenHeight * 0.35,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imagePaths.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(imagePaths.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: _currentPage == index ? 14 : 10,
                              height: _currentPage == index ? 14 : 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // لیست اپراتورها
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      itemCount: operators.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final operator = operators[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServicesScreen(operator: operator),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                            shadowColor: Colors.black45,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<String>(
                                    future: ImageHelper.downloadAndSaveImage(operator.logo),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                        return Image.file(
                                          File(snapshot.data!),
                                          height: 60,
                                          fit: BoxFit.contain,
                                        );
                                      } else {
                                        return const Icon(Icons.broken_image, size: 60);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    operator.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
