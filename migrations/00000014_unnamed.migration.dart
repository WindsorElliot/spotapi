import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration14 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Image", SchemaColumn("isDefault", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    