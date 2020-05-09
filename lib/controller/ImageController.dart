import 'package:spotapi/model/image.dart';
import 'package:spotapi/spotapi.dart';

class ImageController extends ResourceController {
  ImageController({ this.context });

  final ManagedContext context;

  @Operation.get()
  Future<Response> getImages({
    @Bind.query('includeSpot') int includeSpot
  }) async {
    final query = Query<Image>(context);

    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (i) => i.spot);
    }

    final images = await query.fetch();

    return Response.ok(images);
  }

  @Operation.get('id')
  Future<Response> getImageById(@Bind.path('id') int id, {
    @Bind.query('includeSpot') int includeSpot
  }) async {
    final query = Query<Image>(context)..where((i) => i.id).equalTo(id);

    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (i) => i.spot);
    }

    final image = await query.fetchOne();

    return (null != image)
      ? Response.notFound()
      : Response.ok(image);
  }

  @Operation.post()
  Future<Response> createImage(
    @Bind.body(ignore: ['id']) Image image,
    @Bind.query('spotId') int spotId
  ) async {
    final ownerId = request.authorization.ownerID;
    final querySpot = Query<Spot>(context)..where((s) => s.id).equalTo(spotId);
    final spot = await querySpot.fetchOne();

    if (null == spot) {
      return Response.badRequest(body: { "error": "bad spot id" });
    }

    final query = Query<Image>(context)
      ..values = image
      ..values.user.id = ownerId
      ..values.spot = spot;

    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateImage(
    @Bind.path('id') int id, 
    @Bind.body() Map<String, dynamic> data
  ) async {
    if (false == data.containsKey('name') && false == data.containsKey('url')) {
      return Response.badRequest(body: { "error": "body must contain a name or a url" });
    }

    final query = Query<Image>(context)..where((i) => i.id).equalTo(id);

    if (data['name'] != null) {
      query.values.name = data['name'] as String;
    }
    if (data['url'] != null) {
      query.values.url = data['url'] as String;
    }

    final updated = await query.updateOne();

    return (null != updated)
      ? Response.ok(updated)
      : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteImage(@Bind.path('id') int id) async {
    final query = Query<Image>(context)..where((i) => i.id).equalTo(id);

    final deleted = await query.delete();

    return (null != deleted && 0 != deleted)
      ? Response.ok(deleted)
      : Response.notFound();
  }
}