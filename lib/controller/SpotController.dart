import 'package:spotapi/model/departement.dart';
import 'package:spotapi/model/geoloc.dart';
import 'package:spotapi/model/spot.dart';
import 'package:spotapi/model/user.dart';
import 'package:spotapi/spotapi.dart';

class SpotController extends ResourceController {
  SpotController({this.context});

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllSpots({
    @Bind.query('name') String name,
    @Bind.query('includeComments') int includeComments,
    @Bind.query('includeUser') int includeUser,
    @Bind.query('includeGeoloc') int includeGeoloc,
    @Bind.query('includeImage') int includeImage,
    @Bind.query('includeCarpooling') int includeCarpooling,
    @Bind.query('includeDepartement') int includeDepartement
  }) async {
    final query = Query<Spot>(context);
    if (null != name) {
      query.where((spot) => spot.name).contains(name, caseSensitive: false);
    }
    if (null != includeComments && 0 != includeComments) {
      query.join(set: (s) => s.comments).join(object: (c) => c.user);
    }
    if (null != includeUser && 0 != includeUser) {
      query.join(object: (s) => s.user);
    }
    if (null != includeGeoloc && 0 != includeGeoloc) {
      query.join(object: (s) => s.geoloc);
    }
    if (null != includeImage && 0 != includeImage) {
      query.join(set: (s) => s.images);
    }
    if (null != includeCarpooling && 0 != includeCarpooling) {
      query.join(set: (s) => s.carpoolings);
    }
    if (null != includeDepartement && 0 != includeCarpooling) {
      query.join(object: (s) => s.departement);
    }
    
    final spots = await query.fetch();

    return Response.ok(spots);
  }

  @Operation.get('id')
  Future<Response> getSpotByID(@Bind.path('id') int id, {
    @Bind.query('includeComments') int includeComments,
    @Bind.query('includeUser') int includeUser,
    @Bind.query('includeGeoloc') int includeGeoloc,
    @Bind.query('includeImage') int includeImage
  }) async {
    final query = Query<Spot>(context)..where((aSpot) => aSpot.id).equalTo(id);

    if (null != includeComments && 0 != includeComments) {
      query.join(set: (s) => s.comments);
    }
    if (null != includeUser && 0 != includeUser) {
      query.join(object: (s) => s.user);
    }
    if (null != includeGeoloc && 0 != includeGeoloc) {
      query.join(object: (s) => s.geoloc);
    }
    if (null != includeImage && 0 != includeImage) {
      query.join(set: (s) => s.images);
    }

    final aSpot = await query.fetchOne();

    return (null != aSpot)
      ? Response.ok(aSpot)
      : Response.notFound();
  }

  @Operation.post()
  Future<Response> createSpot(
    @Bind.body(ignore: ['id']) Spot spot, 
    @Bind.query('geolocId') int geolocId, 
    @Bind.query('departementId') int departementId
  ) async {
    final ownerId = request.authorization.ownerID;
    final userQuery = Query<User>(context)..where((aUser) => aUser.id).equalTo(ownerId);
    final user = await userQuery.fetchOne();
    final geolocQuery = Query<Geoloc>(context)..where((g) => g.id).equalTo(geolocId);
    final geoloc = await geolocQuery.fetchOne();
    final departementQuery = Query<Departement>(context)..where((d) => d.id).equalTo(departementId);
    final departement = await departementQuery.fetchOne();

    if (null == geoloc || null == user || null == departement) {
      return Response.badRequest();
    }

    spot.user = user;
    spot.geoloc = geoloc;
    spot.departement = departement;

    final query = Query<Spot>(context)
      ..values = spot;

    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateSpot(@Bind.path('id') int id, @Bind.body() Map<String, dynamic> body) async {
    final query = Query<Spot>(context);

    if (false == body.containsKey('name') && false == body.containsKey('note')) {
      return Response.badRequest(body: { "error": "body must contain a name or a note" });
    }

    if (body['name'] != null) {
      query.values.name = body['name'] as String;
    }
    if (body['note'] != null) {
      query.values.note = body['note'] as double;
    }
    query.where((spot) => spot.id).equalTo(id);

    final updatedSpot = await query.updateOne();

    return (null == updatedSpot)
      ? Response.notFound()
      : Response.ok(updatedSpot);
  }

  @Operation.delete('id')
  Future<Response> deleteSpot(@Bind.path('id') int id) async {
    final query = Query<Spot>(context)
      ..where((aSpot) => aSpot.id).equalTo(id);
    
    final deletedSpot = await query.delete();

    return (deletedSpot == 0) 
      ? Response.notFound()
      : Response.ok(deletedSpot);
  }
}