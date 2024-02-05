import 'package:flutter/material.dart';
import 'package:exam_mobile/business_logic/connection_status_manager.dart';
import 'package:exam_mobile/business_logic/books_business_logic.dart';
import 'package:exam_mobile/data_access/app_database.dart';
import 'package:exam_mobile/screens/home_page.dart';
import 'package:exam_mobile/screens/manage_page.dart';
import 'package:exam_mobile/screens/profile_page.dart';
import 'package:exam_mobile/screens/reports_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusManager connectionStatus =
      ConnectionStatusManager.getInstance();
  connectionStatus.initialize();
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final bookBusinessLogic = BookBusinessLogic(database.bookDao);
  runApp(MainApp(bookBusinessLogic: bookBusinessLogic));
}

class MainApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final BookBusinessLogic bookBusinessLogic;

  MainApp({super.key, required this.bookBusinessLogic});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            HomePage.create(scaffoldMessengerKey, bookBusinessLogic),
        '/profile': (context) => ProfilePage.create(scaffoldMessengerKey),
        '/manage': (context) =>
            ManagePage.create(scaffoldMessengerKey, bookBusinessLogic),
        // '/reports': (context) =>
        //     ReportsPage.create(scaffoldMessengerKey, mealBusinessLogic)
      },
    );
  }
}
