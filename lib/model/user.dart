import 'package:aqueduct/managed_auth.dart';
import 'package:spotapi/spotapi.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {}

class _User extends ResourceOwnerTableDefinition {

}