import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../models/operator.dart';
import 'services_sceen.dart';
import '../services/sync_service.dart';
import '../database/db_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _checkAndSyncData();
  }

  Future<void> _checkAndSyncData() async {
    final localOperators = await dbHelper.getOperators();

    if (localOperators.isEmpty) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await syncService.syncAllData();
        futureOperators = dbHelper.getOperators();
      } else {
        futureOperators = Future.value([]);
        print("❌ دیتایی یافت نشد و اینترنت هم وصل نیست.");
      }
    } else {
      futureOperators = Future.value(localOperators);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // چون فقط فارسی دری داریم، راست به چپ است
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
              icon: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.toggleTheme,
            ),
            // منوی تغییر زبان حذف شده چون فقط فارسی داریم
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
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: operators.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
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
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(operator.logo, height: 60),
                          const SizedBox(height: 10),
                          Text(
                            operator.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
