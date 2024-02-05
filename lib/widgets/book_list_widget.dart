import 'package:flutter/material.dart';
import 'package:exam_mobile/data_access/models/book.dart';
import 'package:exam_mobile/widgets/book_info_widget.dart';

class BookListWidget extends StatelessWidget {
  final List<Book> books;

  const BookListWidget({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookInfoWidget(book: books[index]);
      },
    );
  }
}