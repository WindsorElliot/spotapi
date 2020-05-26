import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration15 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("spot", SchemaColumn("type", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    