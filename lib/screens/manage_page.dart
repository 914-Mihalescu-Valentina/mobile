import 'dart:async';

import 'package:flutter/material.dart';
import 'package:exam_mobile/business_logic/connection_status_manager.dart';
import 'package:exam_mobile/business_logic/books_business_logic.dart';
import 'package:exam_mobile/business_logic/web_socket_manager.dart';
import 'package:exam_mobile/screens/add_book_page.dart';
import 'package:exam_mobile/widgets/book_list_widget.dart';

import '../data_access/models/book.dart';

class ManagePage extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final BookBusinessLogic bookBusinessLogic;

  const ManagePage(this.scaffoldMessengerKey, this.bookBusinessLogic,
      {super.key});

  factory ManagePage.create(GlobalKey<ScaffoldMessengerState> key,
      BookBusinessLogic mealBusinessLogic) {
    return ManagePage(key, mealBusinessLogic);
  }

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  ConnectionStatusManager connectionStatus =
  ConnectionStatusManager.getInstance();
  StreamSubscription? _connectionChangeStream;
  WebSocketManager? _webSocketManager;
  List<Book> sortedBooks = [];

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
      _webSocketManager = WebSocketManager(onMessageReceived: (remoteMeal) {
        var book = widget.bookBusinessLogic.addRemoteBook(remoteMeal);
        var message =
            "A new book was added. Title: ${book.title}, author: ${book.author}, genre: ${book.genre}, quantity: ${book.quantity} , reserved: ${book.reserved}";
        openSnackbar('Notification: $message', 2);
      });
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

  void addBook(String title, String author, String genre, int quantity,
      int reserved) async {
    await widget.bookBusinessLogic
        .addBook(title,author, genre, quantity, reserved)
        .then((_) {
      setState(() {});
    }).catchError((e) {
      print('Error adding book: $e');
      openSnackbar("Error adding book: $e", 2);
    });
    setState(() {});
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
          : BookListWidget(books: sortedBooks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddBookPage(onSave: addBook)),
          );
        },
        child: const Icon(Icons.add),
      ),
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
    sortedBooks = await widget.bookBusinessLogic.sortBooks();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
    });
  }
}
