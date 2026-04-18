import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'database.steps.dart';

part 'database.g.dart';

//See https://drift.simonbinder.eu/setup/

//*
// The following commands are also helpful/necessary:
// dart run build_runner build ->generates all the required code once.
// dart run build_runner watch ->watches for changes in your sources and generates code with incremental rebuilds. This is suitable for development sessions.
// *//

enum BlockTypes {
  text,
  colouredblock,
  image,
  doodle,
  fitnessdata,
  location
}
//IMPORTANT: Circular references aren't allowed, so it should be presumed that the first block attached to an entry is the header (the bool col is for double checking ONLY!)
class Blocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<BlockTypes>()();
  TextColumn get txt => text().nullable()();
  BlobColumn get image => blob()();
  IntColumn get parentEntry => integer().references(Entries, #id)();
  IntColumn get positionAmongstSiblings => integer()();
  BoolColumn get isHeader => boolean()();
}

class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text()();
}

@DriftDatabase(tables: [Entries, Blocks])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: stepByStep(
          from1To2: (m, schema) async {
            await m.alterTable(TableMigration(schema.blocks));
          }),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'journal_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}