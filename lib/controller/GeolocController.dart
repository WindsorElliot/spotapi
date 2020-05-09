import 'package:spotapi/model/geoloc.dart';
import 'package:spotapi/spotapi.dart';

class GeolocController extends ResourceController {
  GeolocController({ this.context });

  final ManagedContext context;

  @Operation.get()
  Future<Response> getGeoloc({@Bind.query('includeSpot') int includeSpot}) async {
    final query = Query<Geoloc>(context);

    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (s)=> s.spot);
    }

    final geolocs = await query.fetch();

    return Response.ok(geolocs);
  }

  @Operation.get('id')
  Future<Response> getGeolocById(@Bind.path('id') int id, {@Bind.query('includeSpot') int includeSpot}) async {
    final query = Query<Geoloc>(context)
      ..where((g) => g.id).equalTo(id);

    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (s) => s.spot);
    }

    final geoloc = await query.fetchOne();

    return (null != geoloc)
      ? Response.ok(geoloc)
      : Response.notFound();
  }

  @Operation.post()
  Future<Response> createGeoloc(@Bind.body(ignore: ['id']) Geoloc geoloc) async {
    print(geoloc.lattitude);
    print(geoloc.longitude);

    final query = Query<Geoloc>(context)
      ..values = geoloc;
    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateGeoloc(
    @Bind.path('id') int id,
    @Bind.body() Map<String, dynamic> data
  ) async {
    final query = Query<Geoloc>(context)..where((g) => g.id).equalTo(id);

    if (false == data.containsKey('lattitude') && false == data.containsKey('longitude')) {
      return Response.badRequest(body: { "error": "body must contains a lattitude or a longitude" });
    }

    if (data['lattitude'] != null) {
      query.values.lattitude = data['latittude'] as double;
    }
    if (data['longitude'] != null) {
      query.values.longitude = data['longitude'] as double;
    }

    final updated = query.updateOne();

    return (null != updated) 
      ? Response.ok(updated)
      : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteGeoloc(@Bind.path('id') int id) async {
    final query = Query<Geoloc>(context)..where((g) => g.id).equalTo(id);
    final deleted = await query.delete();

    return (0 != deleted) 
      ? Response.ok(deleted)
      : Response.notFound();
  }

}