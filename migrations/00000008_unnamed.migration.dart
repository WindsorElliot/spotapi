import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration8 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("geoloc", "spot", (c) {c.isNullable = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    