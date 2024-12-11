import 'package:tugas_api/app/models/vendors.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {

     Future<Response> index() async {
      final vendors = await Vendors().query().get();

      return Response.json({'message':'success', 'code':200, 'data': vendors}, 200);
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
      print(request.all());
      try {
        request.validate({
          'vend_id':'required|max_length:5',
          'vend_name': 'required|string|max_length:50',
          'vend_address': 'required|string|max_length:50',
          'vend_kota':'required|string|max_length:20',
          'vend_state':'required|string|max_length:5',
          'vend_zip':'required|string|max_length:7',
          'vend_cauntry':'required|string|max_length:25'
        });

        final vendId = request.input('vend_id');
        final vendName = request.input('vend_name');
        final vendAddress = request.input('vend_address');
        final vendKota = request.input('vend_kota');
        final vendState = request.input('vend_state');
        final vendZip = request.input('vend_zip');
        final vendCauntry = request.input('vend_cauntry');

        var vendID = await Vendors().query().where('vend_id', '=', vendId).first();
        if (vendID != null) {
          return Response.json({
            "message": "Data already exist",
            "code":409
          });
        }

        final vendors = await Vendors().query().insert({
          "vend_id": vendId,
          "vend_name": vendName,
          "vend_address":vendAddress,
          "vend_kota":vendKota,
          "vend_state":vendState,
          "vend_zip": vendZip,
          "vend_cauntry":vendCauntry,
          "created_at": DateTime.now(),
          // "update_at": DateTime.now()
        });

        return Response.json({'message':'Create vendor success', 'code':201, 'data': vendors},201);
      } catch (e) {
        if (e is ValidationException) {
          var errorMessage = e.message;
          return Response.json({'message':errorMessage, 'Code':401},401);
        } else {
          return Response.json({'message':'Internal server error', 'code':500, 'data': e},500);
        }
      }
     }

     Future<Response> show(int id) async {
      final vendors = await Vendors().query().where('vend_id', '=', id.toString()).first();

      return Response.json({"message":"vendor data founded", "code":200, "data":vendors}, 200);
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
      final vendors = await Vendors().query().where('vend_id', '=', id.toString()).first();
      try {
        request.validate({
          'vend_id':'required|max_length:5',
          'vend_name': 'required|string|max_length:50',
          'vend_address': 'required|string|max_length:50',
          'vend_kota':'required|string|max_length:20',
          'vend_state':'required|string|max_length:5',
          'vend_zip':'required|string|max_length:7',
          'vend_cauntry':'required|string|max_length:25'
        });

        final vendId = request.input('vend_id');
        final vendName = request.input('vend_name');
        final vendAddress = request.input('vend_address');
        final vendKota = request.input('vend_kota');
        final vendState = request.input('vend_state');
        final vendZip = request.input('vend_zip');
        final vendCauntry = request.input('vend_cauntry');

        await Vendors().query().where('vend_id', '=', id.toString()).update({
          "vend_id": vendId,
          "vend_name": vendName,
          "vend_address":vendAddress,
          "vend_kota":vendKota,
          "vend_state":vendState,
          "vend_zip": vendZip,
          "vend_cauntry":vendCauntry,
          "update_at": DateTime.now()
        });

        return Response.json({'message':'Update vendors data success', 'code':200, 'data':vendors}, 200);
      } catch (e) {
        return Response.json({'message':'Internal server error', 'code':500}, 500);
      }
     }

     Future<Response> destroy(int id) async {
      final vendors = await Vendors().query().where('vend_id', '=', id.toString()).first();

      if (vendors == null) {
        return Response.json({"message":"vendor data founded", "code":200, "data":vendors}, 200);
      }

      await Vendors().query().where('vend_id', '=', id).delete();

      return Response.json({
        'success': true, 
        "message": "Delet Vendors Data Success", 
        "data":vendors
      });
     }
}

final VendorController vendorController = VendorController();

