import 'package:spotapi/model/user.dart';
import 'package:spotapi/spotapi.dart';

class UserController extends ResourceController {
  UserController({ this.context });

  ManagedContext context;

  @Operation.get()
  Future<Response> getCurrentUser() async {
    final ownerId = request.authorization.ownerID;
    final query = Query<User>(context)..where((u) => u.id).equalTo(ownerId);
    final user = await query.fetchOne();

    return (null != user)
      ? Response.ok(user)
      : Response.notFound();
  }

  @Operation.put()
  Future<Response> updateUser(@Bind.body() Map<String, dynamic> body) async {
    final ownerId = request.authorization.ownerID;
    final query = Query<User>(context)..where((u) => u.id).equalTo(ownerId);
  
    if (body['username'] == null && body['profilImageUrl'] == null && body['email'] == null) {
      return Response.badRequest();
    }

    if (body['username'] != null) {
      query.values.username = body['username'] as String;
    }
    if (body['profilImageUrl'] != null) {
      query.values.profilImageUrl = body['profilImageUrl'] as String;
    }
    if (body['email'] != null) {
      query.values.email = body['email'] as String;
    }

    final updated = await query.updateOne();

    return (null != updated)
      ? Response.ok(updated)
      : Response.notFound();
  }
}