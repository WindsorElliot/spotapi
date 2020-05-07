import 'package:spotapi/spotapi.dart';

class SpotController extends ResourceController {
  SpotController({this.context});

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllSpots({ @Bind.query('name') String name, @Bind.query('clientID') String clientID }) async {
    final query = Query<Spot>(context);
    if (null != name) {
      query.where((spot) => spot.name).contains(name, caseSensitive: false);
    } 
    if (null != clientID) {
      query.where((spot) => spot.clientID).equalTo(clientID);
    }
    final spots = (clientID != null) 
      ? await query.fetchOne()
      : await query.fetch();

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
  Future<Response> createSpot(@Bind.body(ignore: ['id']) Spot spot) async {
    final query = Query<Spot>(context)
      ..values = spot;

    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateSpot(@Bind.path('id') int id, @Bind.body() Map<String, dynamic> body) async {
    final query = Query<Spot>(context);
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