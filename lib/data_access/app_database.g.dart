// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BookDao? _bookDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Books` (`localId` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `title` TEXT NOT NULL, `author` TEXT NOT NULL, `genre` TEXT NOT NULL, `quantity` INTEGER NOT NULL, `reserved` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookInsertionAdapter = InsertionAdapter(
            database,
            'Books',
            (Book item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'genre': item.genre,
                  'quantity': item.quantity,
                  'reserved': item.reserved
                }),
        _bookUpdateAdapter = UpdateAdapter(
            database,
            'Books',
            ['localId'],
            (Book item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'genre': item.genre,
                  'quantity': item.quantity,
                  'reserved': item.reserved
                }),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'Books',
            ['localId'],
            (Book item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'genre': item.genre,
                  'quantity': item.quantity,
                  'reserved': item.reserved
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final UpdateAdapter<Book> _bookUpdateAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Future<List<Book>> getAllBooks() async {
    return _queryAdapter.queryList('SELECT * FROM Books',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            localId: row['localId'] as int?,
            title: row['title'] as String,
            author: row['author'] as String,
            genre: row['genre'] as String,
            quantity: row['quantity'] as int,
            reserved: row['reserved'] as int));
  }

  @override
  Future<void> clearBooks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Books');
  }

  @override
  Future<int> insertBook(Book book) {
    return _bookInsertionAdapter.insertAndReturnId(
        book, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertBooks(List<Book> book) {
    return _bookInsertionAdapter.insertListAndReturnIds(
        book, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBook(Book book) async {
    await _bookUpdateAdapter.update(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBooks(List<Book> books) async {
    await _bookUpdateAdapter.updateList(books, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBook(Book book) async {
    await _bookDeletionAdapter.delete(book);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
