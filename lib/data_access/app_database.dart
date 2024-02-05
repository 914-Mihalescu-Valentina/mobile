// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:exam_mobile/common/helpers/date_time_converter.dart';
import 'package:exam_mobile/data_access/dao/book_dao.dart';
import 'package:exam_mobile/data_access/models/book.dart';

part 'app_database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Book])
abstract class AppDatabase extends FloorDatabase {
  BookDao get bookDao;
}
