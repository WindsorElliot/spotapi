import 'package:aqueduct/aqueduct.dart';
import 'package:spotapi/model/user.dart';
import 'package:uuid/uuid.dart';

enum SpotCodingKeys {
  name,
  note
}

class Spot extends ManagedObject<_Spot> implements _Spot {
  Spot() {
    if (clientID == null) {
      final uid = Uuid();
      clientID = uid.v1();
    }
    
  }
}

@Table(name: "spot")
class _Spot {

  @primaryKey
  int id;

  @Column(indexed: true, nullable: false)
  String name;

  @Column(nullable: true)
  double note;

  @Column(indexed: true, nullable: false, unique: true)
  String clientID;

  @Relate(#spots, isRequired: true, onDelete: DeleteRule.cascade)
  User user;
}