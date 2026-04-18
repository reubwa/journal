// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class Entry extends DataClass implements Insertable<Entry> {
  final int id;
  final DateTime date;
  final String title;
  const Entry({required this.id, required this.date, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      date: Value(date),
      title: Value(title),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
    };
  }

  Entry copyWith({int? id, DateTime? date, String? title}) => Entry(
    id: id ?? this.id,
    date: date ?? this.date,
    title: title ?? this.title,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> title;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
  });
  EntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String title,
  }) : date = Value(date),
       title = Value(title);
  static Insertable<Entry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
    });
  }

  EntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? title,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $BlocksTable extends Blocks with TableInfo<$BlocksTable, Block> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BlockTypes, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BlockTypes>($BlocksTable.$convertertype);
  static const VerificationMeta _txtMeta = const VerificationMeta('txt');
  @override
  late final GeneratedColumn<String> txt = GeneratedColumn<String>(
    'txt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<Uint8List> image = GeneratedColumn<Uint8List>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentEntryMeta = const VerificationMeta(
    'parentEntry',
  );
  @override
  late final GeneratedColumn<int> parentEntry = GeneratedColumn<int>(
    'parent_entry',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entries (id)',
    ),
  );
  static const VerificationMeta _positionAmongstSiblingsMeta =
      const VerificationMeta('positionAmongstSiblings');
  @override
  late final GeneratedColumn<int> positionAmongstSiblings =
      GeneratedColumn<int>(
        'position_amongst_siblings',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isHeaderMeta = const VerificationMeta(
    'isHeader',
  );
  @override
  late final GeneratedColumn<bool> isHeader = GeneratedColumn<bool>(
    'is_header',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_header" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    txt,
    image,
    parentEntry,
    positionAmongstSiblings,
    isHeader,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Block> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('txt')) {
      context.handle(
        _txtMeta,
        txt.isAcceptableOrUnknown(data['txt']!, _txtMeta),
      );
    } else if (isInserting) {
      context.missing(_txtMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('parent_entry')) {
      context.handle(
        _parentEntryMeta,
        parentEntry.isAcceptableOrUnknown(
          data['parent_entry']!,
          _parentEntryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentEntryMeta);
    }
    if (data.containsKey('position_amongst_siblings')) {
      context.handle(
        _positionAmongstSiblingsMeta,
        positionAmongstSiblings.isAcceptableOrUnknown(
          data['position_amongst_siblings']!,
          _positionAmongstSiblingsMeta,
        ),
      );
    }
    if (data.containsKey('is_header')) {
      context.handle(
        _isHeaderMeta,
        isHeader.isAcceptableOrUnknown(data['is_header']!, _isHeaderMeta),
      );
    } else if (isInserting) {
      context.missing(_isHeaderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Block map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Block(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $BlocksTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      txt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}txt'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}image'],
      )!,
      parentEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_entry'],
      )!,
      positionAmongstSiblings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_amongst_siblings'],
      ),
      isHeader: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_header'],
      )!,
    );
  }

  @override
  $BlocksTable createAlias(String alias) {
    return $BlocksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BlockTypes, String, String> $convertertype =
      const EnumNameConverter<BlockTypes>(BlockTypes.values);
}

class Block extends DataClass implements Insertable<Block> {
  final int id;
  final BlockTypes type;
  final String txt;
  final Uint8List image;
  final int parentEntry;
  final int? positionAmongstSiblings;
  final bool isHeader;
  const Block({
    required this.id,
    required this.type,
    required this.txt,
    required this.image,
    required this.parentEntry,
    this.positionAmongstSiblings,
    required this.isHeader,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>($BlocksTable.$convertertype.toSql(type));
    }
    map['txt'] = Variable<String>(txt);
    map['image'] = Variable<Uint8List>(image);
    map['parent_entry'] = Variable<int>(parentEntry);
    if (!nullToAbsent || positionAmongstSiblings != null) {
      map['position_amongst_siblings'] = Variable<int>(positionAmongstSiblings);
    }
    map['is_header'] = Variable<bool>(isHeader);
    return map;
  }

  BlocksCompanion toCompanion(bool nullToAbsent) {
    return BlocksCompanion(
      id: Value(id),
      type: Value(type),
      txt: Value(txt),
      image: Value(image),
      parentEntry: Value(parentEntry),
      positionAmongstSiblings: positionAmongstSiblings == null && nullToAbsent
          ? const Value.absent()
          : Value(positionAmongstSiblings),
      isHeader: Value(isHeader),
    );
  }

  factory Block.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Block(
      id: serializer.fromJson<int>(json['id']),
      type: $BlocksTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      txt: serializer.fromJson<String>(json['txt']),
      image: serializer.fromJson<Uint8List>(json['image']),
      parentEntry: serializer.fromJson<int>(json['parentEntry']),
      positionAmongstSiblings: serializer.fromJson<int?>(
        json['positionAmongstSiblings'],
      ),
      isHeader: serializer.fromJson<bool>(json['isHeader']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $BlocksTable.$convertertype.toJson(type),
      ),
      'txt': serializer.toJson<String>(txt),
      'image': serializer.toJson<Uint8List>(image),
      'parentEntry': serializer.toJson<int>(parentEntry),
      'positionAmongstSiblings': serializer.toJson<int?>(
        positionAmongstSiblings,
      ),
      'isHeader': serializer.toJson<bool>(isHeader),
    };
  }

  Block copyWith({
    int? id,
    BlockTypes? type,
    String? txt,
    Uint8List? image,
    int? parentEntry,
    Value<int?> positionAmongstSiblings = const Value.absent(),
    bool? isHeader,
  }) => Block(
    id: id ?? this.id,
    type: type ?? this.type,
    txt: txt ?? this.txt,
    image: image ?? this.image,
    parentEntry: parentEntry ?? this.parentEntry,
    positionAmongstSiblings: positionAmongstSiblings.present
        ? positionAmongstSiblings.value
        : this.positionAmongstSiblings,
    isHeader: isHeader ?? this.isHeader,
  );
  Block copyWithCompanion(BlocksCompanion data) {
    return Block(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      txt: data.txt.present ? data.txt.value : this.txt,
      image: data.image.present ? data.image.value : this.image,
      parentEntry: data.parentEntry.present
          ? data.parentEntry.value
          : this.parentEntry,
      positionAmongstSiblings: data.positionAmongstSiblings.present
          ? data.positionAmongstSiblings.value
          : this.positionAmongstSiblings,
      isHeader: data.isHeader.present ? data.isHeader.value : this.isHeader,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Block(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('txt: $txt, ')
          ..write('image: $image, ')
          ..write('parentEntry: $parentEntry, ')
          ..write('positionAmongstSiblings: $positionAmongstSiblings, ')
          ..write('isHeader: $isHeader')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    txt,
    $driftBlobEquality.hash(image),
    parentEntry,
    positionAmongstSiblings,
    isHeader,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Block &&
          other.id == this.id &&
          other.type == this.type &&
          other.txt == this.txt &&
          $driftBlobEquality.equals(other.image, this.image) &&
          other.parentEntry == this.parentEntry &&
          other.positionAmongstSiblings == this.positionAmongstSiblings &&
          other.isHeader == this.isHeader);
}

class BlocksCompanion extends UpdateCompanion<Block> {
  final Value<int> id;
  final Value<BlockTypes> type;
  final Value<String> txt;
  final Value<Uint8List> image;
  final Value<int> parentEntry;
  final Value<int?> positionAmongstSiblings;
  final Value<bool> isHeader;
  const BlocksCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.txt = const Value.absent(),
    this.image = const Value.absent(),
    this.parentEntry = const Value.absent(),
    this.positionAmongstSiblings = const Value.absent(),
    this.isHeader = const Value.absent(),
  });
  BlocksCompanion.insert({
    this.id = const Value.absent(),
    required BlockTypes type,
    required String txt,
    required Uint8List image,
    required int parentEntry,
    this.positionAmongstSiblings = const Value.absent(),
    required bool isHeader,
  }) : type = Value(type),
       txt = Value(txt),
       image = Value(image),
       parentEntry = Value(parentEntry),
       isHeader = Value(isHeader);
  static Insertable<Block> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? txt,
    Expression<Uint8List>? image,
    Expression<int>? parentEntry,
    Expression<int>? positionAmongstSiblings,
    Expression<bool>? isHeader,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (txt != null) 'txt': txt,
      if (image != null) 'image': image,
      if (parentEntry != null) 'parent_entry': parentEntry,
      if (positionAmongstSiblings != null)
        'position_amongst_siblings': positionAmongstSiblings,
      if (isHeader != null) 'is_header': isHeader,
    });
  }

  BlocksCompanion copyWith({
    Value<int>? id,
    Value<BlockTypes>? type,
    Value<String>? txt,
    Value<Uint8List>? image,
    Value<int>? parentEntry,
    Value<int?>? positionAmongstSiblings,
    Value<bool>? isHeader,
  }) {
    return BlocksCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      txt: txt ?? this.txt,
      image: image ?? this.image,
      parentEntry: parentEntry ?? this.parentEntry,
      positionAmongstSiblings:
          positionAmongstSiblings ?? this.positionAmongstSiblings,
      isHeader: isHeader ?? this.isHeader,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $BlocksTable.$convertertype.toSql(type.value),
      );
    }
    if (txt.present) {
      map['txt'] = Variable<String>(txt.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List>(image.value);
    }
    if (parentEntry.present) {
      map['parent_entry'] = Variable<int>(parentEntry.value);
    }
    if (positionAmongstSiblings.present) {
      map['position_amongst_siblings'] = Variable<int>(
        positionAmongstSiblings.value,
      );
    }
    if (isHeader.present) {
      map['is_header'] = Variable<bool>(isHeader.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('txt: $txt, ')
          ..write('image: $image, ')
          ..write('parentEntry: $parentEntry, ')
          ..write('positionAmongstSiblings: $positionAmongstSiblings, ')
          ..write('isHeader: $isHeader')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntriesTable entries = $EntriesTable(this);
  late final $BlocksTable blocks = $BlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entries, blocks];
}

typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      required String title,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> title,
    });

final class $$EntriesTableReferences
    extends BaseReferences<_$AppDatabase, $EntriesTable, Entry> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BlocksTable, List<Block>> _blocksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.blocks,
    aliasName: $_aliasNameGenerator(db.entries.id, db.blocks.parentEntry),
  );

  $$BlocksTableProcessedTableManager get blocksRefs {
    final manager = $$BlocksTableTableManager(
      $_db,
      $_db.blocks,
    ).filter((f) => f.parentEntry.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> blocksRefs(
    Expression<bool> Function($$BlocksTableFilterComposer f) f,
  ) {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.parentEntry,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableFilterComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> blocksRefs<T extends Object>(
    Expression<T> Function($$BlocksTableAnnotationComposer a) f,
  ) {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.parentEntry,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          Entry,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (Entry, $$EntriesTableReferences),
          Entry,
          PrefetchHooks Function({bool blocksRefs})
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => EntriesCompanion(id: id, date: date, title: title),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String title,
              }) => EntriesCompanion.insert(id: id, date: date, title: title),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({blocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (blocksRefs) db.blocks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blocksRefs)
                    await $_getPrefetchedData<Entry, $EntriesTable, Block>(
                      currentTable: table,
                      referencedTable: $$EntriesTableReferences
                          ._blocksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EntriesTableReferences(db, table, p0).blocksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.parentEntry == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      Entry,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (Entry, $$EntriesTableReferences),
      Entry,
      PrefetchHooks Function({bool blocksRefs})
    >;
typedef $$BlocksTableCreateCompanionBuilder =
    BlocksCompanion Function({
      Value<int> id,
      required BlockTypes type,
      required String txt,
      required Uint8List image,
      required int parentEntry,
      Value<int?> positionAmongstSiblings,
      required bool isHeader,
    });
typedef $$BlocksTableUpdateCompanionBuilder =
    BlocksCompanion Function({
      Value<int> id,
      Value<BlockTypes> type,
      Value<String> txt,
      Value<Uint8List> image,
      Value<int> parentEntry,
      Value<int?> positionAmongstSiblings,
      Value<bool> isHeader,
    });

final class $$BlocksTableReferences
    extends BaseReferences<_$AppDatabase, $BlocksTable, Block> {
  $$BlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntriesTable _parentEntryTable(_$AppDatabase db) => db.entries
      .createAlias($_aliasNameGenerator(db.blocks.parentEntry, db.entries.id));

  $$EntriesTableProcessedTableManager get parentEntry {
    final $_column = $_itemColumn<int>('parent_entry')!;

    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentEntryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BlocksTableFilterComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BlockTypes, BlockTypes, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get txt => $composableBuilder(
    column: $table.txt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionAmongstSiblings => $composableBuilder(
    column: $table.positionAmongstSiblings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHeader => $composableBuilder(
    column: $table.isHeader,
    builder: (column) => ColumnFilters(column),
  );

  $$EntriesTableFilterComposer get parentEntry {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentEntry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get txt => $composableBuilder(
    column: $table.txt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionAmongstSiblings => $composableBuilder(
    column: $table.positionAmongstSiblings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHeader => $composableBuilder(
    column: $table.isHeader,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntriesTableOrderingComposer get parentEntry {
    final $$EntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentEntry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableOrderingComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BlockTypes, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get txt =>
      $composableBuilder(column: $table.txt, builder: (column) => column);

  GeneratedColumn<Uint8List> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get positionAmongstSiblings => $composableBuilder(
    column: $table.positionAmongstSiblings,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHeader =>
      $composableBuilder(column: $table.isHeader, builder: (column) => column);

  $$EntriesTableAnnotationComposer get parentEntry {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentEntry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlocksTable,
          Block,
          $$BlocksTableFilterComposer,
          $$BlocksTableOrderingComposer,
          $$BlocksTableAnnotationComposer,
          $$BlocksTableCreateCompanionBuilder,
          $$BlocksTableUpdateCompanionBuilder,
          (Block, $$BlocksTableReferences),
          Block,
          PrefetchHooks Function({bool parentEntry})
        > {
  $$BlocksTableTableManager(_$AppDatabase db, $BlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<BlockTypes> type = const Value.absent(),
                Value<String> txt = const Value.absent(),
                Value<Uint8List> image = const Value.absent(),
                Value<int> parentEntry = const Value.absent(),
                Value<int?> positionAmongstSiblings = const Value.absent(),
                Value<bool> isHeader = const Value.absent(),
              }) => BlocksCompanion(
                id: id,
                type: type,
                txt: txt,
                image: image,
                parentEntry: parentEntry,
                positionAmongstSiblings: positionAmongstSiblings,
                isHeader: isHeader,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required BlockTypes type,
                required String txt,
                required Uint8List image,
                required int parentEntry,
                Value<int?> positionAmongstSiblings = const Value.absent(),
                required bool isHeader,
              }) => BlocksCompanion.insert(
                id: id,
                type: type,
                txt: txt,
                image: image,
                parentEntry: parentEntry,
                positionAmongstSiblings: positionAmongstSiblings,
                isHeader: isHeader,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BlocksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({parentEntry = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (parentEntry) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentEntry,
                                referencedTable: $$BlocksTableReferences
                                    ._parentEntryTable(db),
                                referencedColumn: $$BlocksTableReferences
                                    ._parentEntryTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlocksTable,
      Block,
      $$BlocksTableFilterComposer,
      $$BlocksTableOrderingComposer,
      $$BlocksTableAnnotationComposer,
      $$BlocksTableCreateCompanionBuilder,
      $$BlocksTableUpdateCompanionBuilder,
      (Block, $$BlocksTableReferences),
      Block,
      PrefetchHooks Function({bool parentEntry})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db, _db.blocks);
}
