import 'package:floor/floor.dart';

@Entity(tableName: 'Books')
class Book {
  @PrimaryKey(autoGenerate: true)
  int? localId;
  int? id;
  final String title;
  final String author;
  final String genre;
  final int quantity;
  final int reserved;

  Book(
      {this.id,
      this.localId,
      required this.title,
      required this.author,
      required this.genre,
      required this.quantity,
      required this.reserved});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"] ?? "",
        author: json["author"] ?? "",
        genre: json["genre"] ?? "",
        quantity: json["quantity"] + 0,
        reserved: json["reserved"] + 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "genre": genre,
        "quantity": quantity,
        "reserved": reserved
      };
}
