import 'package:spotapi/controller/CommentController.dart';
import 'package:spotapi/controller/GeolocController.dart';
import 'package:spotapi/controller/RegisterController.dart';
import 'package:spotapi/controller/SpotController.dart';
import 'package:spotapi/model/user.dart';

import 'spotapi.dart';


class SpotapiChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      "admin_rightspot", 
      "rightspotpassword", 
      "localhost", 
      5432, 
      "rightspot"
    );

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    context = ManagedContext(dataModel, persistentStore);
    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);

  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/spot/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => SpotController(context: context));

    router
      .route("/geoloc/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => GeolocController(context: context));

    router
      .route("/comment/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => CommentController(context: context));

    router
      .route("/register")
      .link(() => RegisterController(context: context, authServer: authServer));

    router
      .route("/auth/token")
      .link(() => AuthController(authServer));

    router
      .route("/isAlive")
      .linkFunction((request) async {
        return Response.ok({"live": "true"});
      });

    return router;
  }
}