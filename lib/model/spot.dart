import 'package:aqueduct/aqueduct.dart';
import 'package:spotapi/model/carpooling.dart';
import 'package:spotapi/model/comment.dart';
import 'package:spotapi/model/departement.dart';
import 'package:spotapi/model/geoloc.dart';
import 'package:spotapi/model/image.dart';
import 'package:spotapi/model/user.dart';
import 'package:uuid/uuid.dart';

enum SpotType {
  reffBreak,
  beachBreak,
  pointBreak,
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

  @Column(indexed: false, nullable: true)
  String description;

  @Column(indexed: true, nullable: false)
  SpotType type;

  @Relate(#spots, isRequired: true, onDelete: DeleteRule.cascade)
  User user;

  @Relate(#spot, isRequired: true, onDelete: DeleteRule.cascade)
  Geoloc geoloc;

  ManagedSet<Comment> comments;

  ManagedSet<Image> images;

  ManagedSet<Carpooling> carpoolings;

  @Relate(#spots, isRequired: true, onDelete: DeleteRule.cascade)
  Departement departement;

}