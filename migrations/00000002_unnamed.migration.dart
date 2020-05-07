import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("spot", "name", (c) {c.isIndexed = true;});
		database.alterColumn("spot", "note", (c) {c.isNullable = true;});
		database.alterColumn("spot", "clientID", (c) {c.isIndexed = true;c.isUnique = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    