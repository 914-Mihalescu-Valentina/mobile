import 'package:flutter/material.dart';
import 'package:exam_mobile/data_access/models/book.dart';

import '../business_logic/books_business_logic.dart';

class BookInfoWidgetForHomePage extends StatefulWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;
  final Book book;
  final bool isDeleteEnabled;
  final BookBusinessLogic businessLogic;
  const BookInfoWidgetForHomePage(
      {Key? key,
        required this.book,
        this.onDelete,
        this.isDeleteEnabled = false,
        required this.businessLogic,
        this.onUpdate})
      : super(key: key);

  @override
  State<BookInfoWidgetForHomePage> createState() => _BookInfoWidgetForHomePageState();
}

class _BookInfoWidgetForHomePageState extends State<BookInfoWidgetForHomePage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${widget.book.title}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Author: ${widget.book.author}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Genre: ${widget.book.genre} Genre',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Quantity: ${widget.book.quantity}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 300,
                      child: Text(
                        '# Reserved: ${widget.book.reserved}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                if (widget.isDeleteEnabled)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      widget.onDelete!();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _showReservationDialog(context);
              },
              child: Text('Reserve/Borrow'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReservationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an option'),
          actions: [
            TextButton(
              onPressed: () async {
                await widget.businessLogic.reserveBook(widget.book.id);
                setState(() {
                  widget.onUpdate?.call();
                });
                Navigator.of(context).pop();
              },
              child: Text('Reserve'),
            ),
            TextButton(
              onPressed: () async {
                await widget.businessLogic.borrowBook(widget.book.id);
                setState(() {
                  widget.onUpdate?.call();
                });
                Navigator.of(context).pop();
              },
              child: Text('Borrow'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
