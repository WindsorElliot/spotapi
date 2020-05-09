import 'package:spotapi/model/spot.dart';
import 'package:spotapi/model/user.dart';
import 'package:spotapi/spotapi.dart';

class Image extends ManagedObject<_Image> implements _Image {

}

class _Image {

  @primaryKey
  int id;

  @Column(indexed: true, nullable: false)
  String name;

  @Column(indexed: false, nullable: false)
  String url;

  @Relate(#images, isRequired: true, onDelete: DeleteRule.cascade)
  Spot spot;

  @Relate(#images, isRequired: true, onDelete: DeleteRule.cascade)
  User user;

}