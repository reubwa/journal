import 'package:journalapp/database.dart';

Future<Block?> getHeader(int entryId) async {
  final database = AppDatabase();
  final query = database.select(database.blocks);
  query.where((fil)=>fil.isHeader.equals(true));
  query.where((fil)=>fil.parentEntry.equals(entryId));
  query.where((fil)=>fil.positionAmongstSiblings.equals(0));
  return(await query.getSingleOrNull());
}