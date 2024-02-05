import 'package:exam_mobile/business_logic/books_business_logic.dart';
import 'package:flutter/material.dart';
import 'package:exam_mobile/data_access/models/book.dart';
import 'package:exam_mobile/widgets/book_info_widget_for_home_page.dart';

class BookListWidgetForHomePage extends StatelessWidget {
  final List<Book> books;
  final BookBusinessLogic businessLogic;
  const BookListWidgetForHomePage({super.key, required this.books,required this.businessLogic});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookInfoWidgetForHomePage(book: books[index],businessLogic:businessLogic);
      },
    );
  }
}