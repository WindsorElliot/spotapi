import 'package:aqueduct/managed_auth.dart';
import 'package:spotapi/controller/SpotController.dart';
import 'package:spotapi/model/user.dart';

import 'spotapi.dart';


class SpotapiChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      "admin_rightspot", 
      "rightspotpassword", 
      "localhost", 
      5432, 
      "rightspot"
    );
    final authStorage = ManagedAuthDelegate<User>(context);

    context = ManagedContext(dataModel, persistentStore);
    authServer = AuthServer(authStorage);

  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/spot/[:id]")
      .link(() => SpotController(context: context));

    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    return router;
  }
}