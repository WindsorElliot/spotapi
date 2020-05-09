import 'package:spotapi/model/carpooling.dart';
import 'package:spotapi/model/user.dart';
import 'package:spotapi/spotapi.dart';

class Traveler extends ManagedObject<_Traveler> implements _Traveler {

}

class _Traveler {
  @primaryKey
  int id;

  @Relate(#travelers, isRequired: true, onDelete: DeleteRule.cascade)
  User user;

  @Relate(#travelers, isRequired: true, onDelete: DeleteRule.cascade)
  Carpooling carpooling;
}