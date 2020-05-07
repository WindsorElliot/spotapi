import 'package:aqueduct/managed_auth.dart';
import 'package:spotapi/spotapi.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  
  @Column(indexed: true, nullable: false)
  String email;

  ManagedSet<Spot> spots;
}