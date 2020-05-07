import 'package:spotapi/spotapi.dart';

class RegisterController extends ResourceController {
  RegisterController({ this.context, this.authServer });

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null || user.email == null) {
      return Response.badRequest(body: { "error": "username, password and email are required" });
    }
    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    final inserted = await Query(context, values: user).insert();

    return Response.ok(inserted);
  }

}