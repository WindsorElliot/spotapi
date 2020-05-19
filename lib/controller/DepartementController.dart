import 'package:spotapi/model/departement.dart';
import 'package:spotapi/spotapi.dart';

class DepartementController extends ResourceController {
  DepartementController({ this.context });

  final ManagedContext context;

  @Operation.get()
  Future<Response> getDepartements({
    @Bind.query("includeSpots") int includeSpots
  }) async {
    final query = Query<Departement>(context);
    if (null != includeSpots && 0 != includeSpots) {
      query.join(set: (d) => d.spots);
    }

    final departements = await query.fetch();

    return Response.ok(departements);
  }

  @Operation.get('id')
  Future<Response> getDepartementById(@Bind.path('id') int id, {
    @Bind.query("includeSpots") int includeSpots
  }) async {
    final query = Query<Departement>(context)..where((s) => s.id).equalTo(id);
    if (null != includeSpots && 0 != includeSpots) {
      query.join(set: (d) => d.spots);
    }

    final departement = await query.fetchOne();

    return (null != departement)
      ? Response.ok(departement)
      : Response.notFound();
  }
}