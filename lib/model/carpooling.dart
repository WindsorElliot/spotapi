import 'package:spotapi/model/traveler.dart';
import 'package:spotapi/spotapi.dart';
import 'package:spotapi/model/user.dart';
import 'package:spotapi/model/spot.dart';

class Carpooling extends ManagedObject<_Carpooling> implements _Carpooling {
}

class _Carpooling {

  @primaryKey
  int id;

  @Column(indexed: true, nullable: false)
  DateTime travelDate;

  @Column(indexed: false, nullable: false)
  int avaiblePlace;

  @Relate(#carpoolings, isRequired: true, onDelete: DeleteRule.cascade)
  User creator;

  @Relate(#carpoolings, isRequired: true, onDelete: DeleteRule.cascade)
  Spot spot;

  @Column(indexed: false, nullable: false)
  double startLattitude;

  @Column(indexed: false, nullable: false)
  double startLongitude;

  ManagedSet<Traveler> travelers;

}