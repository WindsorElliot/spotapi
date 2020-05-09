import 'package:spotapi/model/carpooling.dart';
import 'package:spotapi/model/spot.dart';
import 'package:spotapi/model/traveler.dart';
import 'package:spotapi/spotapi.dart';

class CarpoolingController extends ResourceController {
  CarpoolingController({ this.context });

  final ManagedContext context;

  @Operation.get()
  Future<Response> getCarpooling({
    @Bind.query('includeTraveler') int includeTraveler,
    @Bind.query('includeSpot') int includeSpot,
    @Bind.query('includeCreator') int includeCreator
  }) async {
    final query = Query<Carpooling>(context)..where((c) => c.travelDate).greaterThan(DateTime.now());

    if (null != includeCreator && 0 != includeCreator) {
      query.join(object: (c) => c.creator);
    }
    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (c) => c.spot);
    }
    if (null != includeTraveler && 0 != includeTraveler) {
      query.join(set: (c) => c.travelers).join(object: (t) => t.user);
    }

    final carpoolings = await query.fetch();

    return Response.ok(carpoolings);
  }

  @Operation.get('id')
  Future<Response> getCarPoolingById(@Bind.path('id') int id, {
    @Bind.query('includeTraveler') int includeTraveler,
    @Bind.query('includeSpot') int includeSpot,
    @Bind.query('includeCreator') int includeCreator
  }) async {
    final query = Query<Carpooling>(context)..where((c) => c.id).equalTo(id);

    if (null != includeCreator && 0 != includeCreator) {
      query.join(object: (c) => c.creator);
    }
    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (c) => c.spot);
    }
    if (null != includeTraveler && 0 != includeTraveler) {
      query.join(set: (c) => c.travelers).join(object: (t) => t.user);
    }

    final carPooling = await query.fetchOne();

    return (null != carPooling)
      ? Response.ok(carPooling)
      : Response.notFound();
  }

  @Operation.post()
  Future<Response> createCarPooling(
    @Bind.body(ignore: ['id']) Carpooling carpooling,
    @Bind.query('spotId') int spotId
  ) async {
    final ownerId = request.authorization.ownerID;
    final spotQuery = Query<Spot>(context)..where((s) => s.id).equalTo(spotId);
    final spot = await spotQuery.fetchOne();

    if (null == spot) {
      return Response.badRequest(body: { "error": "spot not found " });
    }

    final query = Query<Carpooling>(context)
      ..values = carpooling
      ..values.creator.id = ownerId
      ..values.spot = spot;

    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateCarpooling(
    @Bind.path('id') int id, 
    @Bind.body() Map<String, dynamic> data
  ) async {
    if (false == data.containsKey('travelDate') && false == data.containsKey('startLattitude') && false == data.containsKey('startLongitude')) {
      return Response.badRequest(body: { "error": "body must contain a tarvelDate or datrtLattitude or startLongitude" });
    }

    final query = Query<Carpooling>(context)..where((c) => c.id).equalTo(id);

    if (null != data['travelDate']) {
      query.values.travelDate = DateTime.fromMillisecondsSinceEpoch(data['travelDate'] as int);
    }
    if (null != data['startLattitude']) {
      query.values.startLattitude = data['startLattitude'] as double;
    }
    if (null != data['startLongitude']) {
      query.values.startLongitude = data['startLongitude'] as double;
    }

    final updated = await query.updateOne();

    return (null != updated)
      ? Response.ok(updated)
      : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteCarpooling(@Bind.path('id') int id) async {
    final query = Query<Carpooling>(context)..where((c) => c.id).equalTo(id);

    final deleted = await query.delete();

    return (null != deleted && 0 != deleted)
      ? Response.ok(deleted)
      : Response.notFound();
  }

  @Operation.post('id')
  Future<Response> addTraveler(@Bind.path('id') int id) async {
    final ownerId = request.authorization.ownerID;
    final query = Query<Carpooling>(context)..where((c) => c.id).equalTo(id);
    final carpooling = await query.fetchOne();

    if (null == carpooling) {
      return Response.badRequest(body: { "error": "carpooling not found" });
    }

    final queryTraveler = Query<Traveler>(context)
      ..values.user.id = ownerId
      ..values.carpooling = carpooling;

    final inserted = await queryTraveler.insert();

    return Response.ok(inserted);
  }
}