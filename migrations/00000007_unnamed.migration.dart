import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration7 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("geoloc", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("lattitude", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("longitude", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("geoloc", SchemaColumn.relationship("spot", ManagedPropertyType.bigInteger, relatedTableName: "spot", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: true));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    