import 'package:spotapi/controller/CarpoolingController.dart';
import 'package:spotapi/controller/CommentController.dart';
import 'package:spotapi/controller/DepartementController.dart';
import 'package:spotapi/controller/GeolocController.dart';
import 'package:spotapi/controller/ImageController.dart';
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

    final config = SpotApiConfig(options.configurationFilePath);
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password, 
      config.database.host, 
      config.database.port, 
      config.database.databaseName
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
      .route("/image/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => ImageController(context: context));

    router
      .route("/carpooling/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => CarpoolingController(context: context));

    router
      .route("departement/[:id]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => DepartementController(context: context));

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

class SpotApiConfig extends Configuration {
  SpotApiConfig(String filePath) : super.fromFile(File(filePath));

  DatabaseConfiguration database;
}