import 'package:floor/floor.dart';
import 'package:exam_mobile/data_access/models/book.dart';

@dao
abstract class BookDao {
  @Query('SELECT * FROM Books')
  Future<List<Book>> getAllBooks();

  @insert
  Future<int> insertBook(Book book);

  @insert
  Future<List<int>> insertBooks(List<Book> book);

  @delete
  Future<void> deleteBook(Book book);

  @Query('DELETE FROM Books')
  Future<void> clearBooks();

  @update
  Future<void> updateBook(Book book);

  @update
  Future<void> updateBooks(List<Book> books);
}