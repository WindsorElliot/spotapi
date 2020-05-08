import 'package:spotapi/spotapi.dart';

class Geoloc extends ManagedObject<_Geoloc> implements _Geoloc {

}

@Table(name: 'geoloc')
class _Geoloc {

  @primaryKey
  int id;

  @Column(nullable: false)
  double lattitude;

  @Column(nullable: false)
  double longitude;

  Spot spot;

}