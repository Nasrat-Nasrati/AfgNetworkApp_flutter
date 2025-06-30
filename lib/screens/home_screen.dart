import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../models/operator.dart';
import 'services_sceen.dart';
import '../generated/l10n.dart';
import '../services//sync_service.dart';
import '../database/db_helper.dart';





class HomeScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  final void Function() toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.setLocale,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final SyncService syncService = SyncService();
  late Future<List<Operator>> futureOperators;

  @override
  void initState() {
    super.initState();
    _checkAndSyncData();
  }

  Future<void> _checkAndSyncData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await syncService.syncAllData();
      futureOperators = apiService.fetchAllOperators(); // آنلاین
    } else {
      futureOperators = DatabaseHelper().getOperators(); // ✅ درست

      print("شما در حالت آفلاین هستید.");
    }
    setState(() {});
  }

  void _changeLanguage(String langCode) {
    Locale newLocale = Locale(langCode);
    widget.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final String currentLang = Localizations.localeOf(context).languageCode;
    final bool isRtl = currentLang == 'fa' || currentLang == 'ps';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title: Text(S.of(context).appTitle),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: widget.isDarkMode
                  ? S.of(context).lightMode
                  : S.of(context).darkMode,
              icon: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.toggleTheme,
            ),
            PopupMenuButton<String>(
              onSelected: _changeLanguage,
              itemBuilder: (context) => [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'fa', child: Text('دری')),
                PopupMenuItem(value: 'ps', child: Text('پښتو')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Operator>>(
          future: futureOperators,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('❌ ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(S.of(context).noOperatorsFound));
            }

            final operators = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: operators.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          SizedBox(height: 10),
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


