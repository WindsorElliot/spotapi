import 'package:spotapi/model/geoloc.dart';
import 'package:spotapi/spotapi.dart';

class SpotController extends ResourceController {
  SpotController({this.context});

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllSpots({ @Bind.query('name') String name}) async {
    final query = Query<Spot>(context);
    if (null != name) {
      query.where((spot) => spot.name).contains(name, caseSensitive: false);
    } 
    final spots = await query.fetch();

    return Response.ok(spots);
  }

  @Operation.get('id')
  Future<Response> getSpotByID(@Bind.path('id') int id) async {
    final query = Query<Spot>(context)
      ..where((aSpot) => aSpot.id).equalTo(id);

    final aSpot = await query.fetchOne();

    return (null != aSpot)
      ? Response.ok(aSpot)
      : Response.notFound();
  }

  @Operation.post()
  Future<Response> createSpot(@Bind.body(ignore: ['id']) Spot spot, @Bind.query('geolocId') int geolocId) async {
    final ownerId = request.authorization.ownerID;
    final userQuery = Query<User>(context)..where((aUser) => aUser.id).equalTo(ownerId);
    final user = await userQuery.fetchOne();
    final geolocQuery = Query<Geoloc>(context)..where((g) => g.id).equalTo(geolocId);
    final geoloc = await geolocQuery.fetchOne();

    if (null == geoloc || null == user) {
      return Response.badRequest();
    }

    spot.user = user;
    spot.geoloc = geoloc;

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