import 'dart:async';

import 'package:flutter/material.dart';
import 'package:exam_mobile/business_logic/connection_status_manager.dart';
import 'package:exam_mobile/business_logic/books_business_logic.dart';
import 'package:exam_mobile/business_logic/web_socket_manager.dart';
import 'package:exam_mobile/widgets/book_list_widget_for_home_page.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final BookBusinessLogic bookBusinessLogic;

  const HomePage(this.scaffoldMessengerKey, this.bookBusinessLogic,
      {super.key});

  factory HomePage.create(GlobalKey<ScaffoldMessengerState> key,
      BookBusinessLogic mealBusinessLogic) {
    return HomePage(key, mealBusinessLogic);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectionStatusManager connectionStatus =
      ConnectionStatusManager.getInstance();
  StreamSubscription? _connectionChangeStream;
  WebSocketManager? _webSocketManager;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _connectionChangeStream =
        connectionStatus.connectionChange.listen(_connectionChanged);
    connectionStatus.hasNetwork();
  }

  @override
  void dispose() {
    _webSocketManager?.disconnect();
    ConnectionStatusManager.getInstance().dispose();
    widget.bookBusinessLogic.updateBooks();
    super.dispose();
  }

  void openSnackbar(String message, int durationInSeconds) {
    widget.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: durationInSeconds),
      ),
    );
  }

  void _connectionChanged(dynamic hasNetwork) {
    if (!widget.bookBusinessLogic.hasNetwork && hasNetwork) {
      openSnackbar(
          "You are connected to internet. Your application has been updated with the server.",
          2);
      widget.bookBusinessLogic.hasNetwork = true;
    } else if (!hasNetwork) {
      openSnackbar(
          "There is no connection to internet! Loaded from local database.", 2);
      _webSocketManager?.disconnect();
      _webSocketManager = null;
      widget.bookBusinessLogic.hasNetwork = false;
      widget.bookBusinessLogic.saveBooks();
    }
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _loading || widget.bookBusinessLogic.books.isEmpty
          ? Center(
              child: Column(children: [
              const CircularProgressIndicator(),
              const Text("Waiting for internet connection"),
              ElevatedButton(
                  onPressed: () => connectionStatus.hasNetwork(),
                  child: const Text("Retry connection"))
            ]))
          : BookListWidgetForHomePage(books: widget.bookBusinessLogic.books,businessLogic: widget.bookBusinessLogic),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drag_handle),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration),
            label: 'Reports',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 1:
              if (!widget.bookBusinessLogic.hasNetwork) {
                openSnackbar(
                    "You cannot access this section while offline.", 1);
              } else {
                Future pushNamed = Navigator.pushNamed(context, '/manage');
                pushNamed.then((_) => setState(() {}));
              }
              break;
            case 2:
              if (!widget.bookBusinessLogic.hasNetwork) {
                openSnackbar(
                    "You cannot access this section while offline.", 1);
              } else {
                Navigator.pushNamed(context, '/reports');
              }
              break;
          }
        },
      ),
    );
  }

  fetchData() async {
    await widget.bookBusinessLogic.syncLocalDbWithServer();
    await widget.bookBusinessLogic.getAllBooks();
    setState(() {
      _loading = false;
    });
  }


}
