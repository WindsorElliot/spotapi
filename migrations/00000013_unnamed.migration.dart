import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration13 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Departement", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("departement", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false)]));
		database.addColumn("spot", SchemaColumn.relationship("departement", ManagedPropertyType.bigInteger, relatedTableName: "_Departement", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {
   final data = ["pasDeCalais", "somme", "seineMaritime", "eure", "calvados", "manche", "illeEtVilaine", "cotesDArmor", "finistere", "morbihan", "loireAtlantique", "vendee", "charenteMaritime", "gironde", "landes", "pyreneeAtlantique", "pyreneeOrientale", "aude", "herault", "gard", "boucheDuRhone", "vars", "alpesMaritimes", "hautCorse", "corseSud", "guadeloupe", "martinique", "guyane", "mayote", "reunion", "saintPierreEtMiquelon"];
    for (final aDepartement in data) {
      await database.store.execute("INSERT INTO _Departement (departement) VALUES (@departement)", substitutionValues: {
        "departement": aDepartement
      });
    }
  }
}
    