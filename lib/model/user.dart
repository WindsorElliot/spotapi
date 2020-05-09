import 'package:aqueduct/managed_auth.dart';
import 'package:spotapi/model/comment.dart';
import 'package:spotapi/model/image.dart';
import 'package:spotapi/spotapi.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  
  @Column(indexed: true, nullable: false)
  String email;

  ManagedSet<Spot> spots;
  
  ManagedSet<Comment> comments;

  ManagedSet<Image> images;

}