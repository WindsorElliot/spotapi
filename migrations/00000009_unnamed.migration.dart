import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration9 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("spot", SchemaColumn.relationship("geoloc", ManagedPropertyType.bigInteger, relatedTableName: "geoloc", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: true));
		database.deleteColumn("geoloc", "spot");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    