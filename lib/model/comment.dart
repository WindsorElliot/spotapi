import 'package:spotapi/spotapi.dart';

class Comment extends ManagedObject<_Comment> implements _Comment {

}

@Table(name: 'comment')
class _Comment {

  @primaryKey
  int id;

  @Column(indexed: false, nullable: false)
  String comment;

  @Relate(#comments, isRequired: true)
  User user;
}