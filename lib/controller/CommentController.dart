import 'package:spotapi/model/comment.dart';
import 'package:spotapi/spotapi.dart';

class CommentController extends ResourceController {
  CommentController({ this.context });

  final ManagedContext context;

  @Operation.get()
  Future<Response> getComments({
    @Bind.query('includeSpot') int includeSpot,
    @Bind.query('includeUser') int includeUser
  }) async {
    final query = Query<Comment>(context);
    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (c) => c.spot);
    }
    if (null != includeUser && 0 != includeUser) {
      query.join(object: (c) => c.user);
    }

    final comments = await query.fetch();

    return Response.ok(comments);
  }

  @Operation.get('id')
  Future<Response> getCommentById(@Bind.path('id') int id, {
    @Bind.query('includeSpot') int includeSpot,
    @Bind.query('includeUser') int includeUser
  }) async {
    final query = Query<Comment>(context)..where((c) => c.id).equalTo(id);

    if (null != includeSpot && 0 != includeSpot) {
      query.join(object: (c) => c.spot);
    }
    if (null != includeUser && 0 != includeUser) {
      query.join(object: (c) => c.user);
    }

    final comment = await query.fetchOne();

    return (null != comment)
      ? Response.ok(comment)
      : Response.notFound(); 
  }

  @Operation.post()
  Future<Response> createComment(
    @Bind.body(ignore: ['id']) Comment comment, 
    @Bind.query('spotId') int spotId) 
  async {
    final ownerId = request.authorization.ownerID;
    final userQuery = Query<User>(context)..where((u) => u.id).equalTo(ownerId);
    final user = await userQuery.fetchOne();
    final querySpot = Query<Spot>(context)..where((s) => s.id).equalTo(spotId);
    final spot = await querySpot.fetchOne();

    if (null == spot || null == user) {
      return Response.badRequest();
    }

    comment.user = user;
    comment.spot = spot;

    final query = Query<Comment>(context)..values = comment;
    final inserted = await query.insert();

    return Response.ok(inserted);
  }

  @Operation.put('id')
  Future<Response> updateComment(
    @Bind.path('id') int id,
    @Bind.body() Map<String, dynamic> data
  ) async {
    final query = Query<Comment>(context)..where((c) => c.id).equalTo(id);

    if (false == data.containsKey('comment')) {
      return Response.badRequest(body: { "error": "body must contain a comment" });
    }

    if (null != data['comment']) {
      query.values.comment = data['comment'] as String;
    }

    final updated = await query.updateOne();

    return (null != updated)
      ? Response.ok(updated)
      : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteComment(@Bind.path('id') int id) async {
    final query = Query<Comment>(context)..where((c) => c.id).equalTo(id);
    final deleted = await query.delete();

    return (null == deleted || 0 == deleted)
      ? Response.notFound()
      : Response.ok(deleted);
  }

}