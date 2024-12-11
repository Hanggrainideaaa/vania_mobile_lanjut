import 'package:tugas_api/app/models/products.dart';
import 'package:tugas_api/app/models/vendors.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {

     Future<Response> index() async {
      final products = await Products().query()
      .join('vendors', 'vendors.vend_id', '=', 'products.vend_id')
      .leftJoin('productnotes', 'productnotes.note_id', '=', 'products.prod_id')
      .select([
        'products.prod_id',
        'products.prod_name',
        'products.prod_price',
        'products.prod_decs',
        'vendors.vend_name as vendor_name',
        'productnotes.note_text  as product_note',
        'productnotes.note_date as note_date'
      ]).get();

      return Response.json({'message':'success', 'code':200, 'data': products});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
      try {
        request.validate({
          'prod_id': 'required|max_legth:5',
          'vend_id': 'required|string|max_length:50',
          'prod_name': 'required|string|max_length:50',
          'prod_price': 'required|string|max_length:20',
          'prod_desc': 'required|string|max_length:5'
        });

        final prodId = request.input('prod_id');
        final vendId = request.input('vend_id');
        final prodName = request.input('prod_name');
        final prodPrice = request.input('prod_price');
        final prodDesc = request.input('prod_desc');

        final vendors = await Vendors().query().where('vend_id', '=', request.input('vend_id').toString()).first();

        if (vendors == null) {
          return Response.json({
            'success': false,
            'message': 'vendor not found'
          },404);
        }

        var prodID = await Products().query().where('prod_id', '=', prodId).first();
        if (prodID !=  null) {
          return Response.json({
            "message": "Data already exist",
            "code":409
          });
        }

        final products = await Products().query().insert({
          "prod_id":prodId,
          "vend_id":vendId,
          "prod_name":prodName,
          "prod_price":prodPrice,
          "prod_desc":prodDesc,
          "created_at": DateTime.now(),
          "updated_at": DateTime.now()
        });

        return Response.json({'message':'Create vendor success', 'code':201, 'data': products},201);
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
      final products = await Products().query().where('prod_id', '=', id.toString()).first();

      return Response.json({"message": "Vendor Data Founded", "code": 200, "data": products},200);
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
      final products = await Products().query().where('prod_id', '=', id.toString()).first();

      try {
        request.validate({
          'prod_id': 'required|max_legth:5',
          'vend_id': 'required|string|max_length:50',
          'prod_name': 'required|string|max_length:50',
          'prod_price': 'required|string|max_length:20',
          'prod_desc': 'required|string|max_length:5'
        });

        final prodId = request.input('prod_id');
        final vendId = request.input('vend_id');
        final prodName = request.input('prod_name');
        final prodPrice = request.input('prod_price');
        final prodDesc = request.input('prod_desc');

        final vendors = await Vendors().query().where('vend_id', '=', request.input('vend_id').toString()).first();

        if (vendors == null) {
          return Response.json({
            'success': false,
            'message': 'vendor not found'
          },404);
        }

        await Products().query().where('prod_id', '=', id.toString()).update({
          "prod_id":prodId,
          "vend_id":vendId,
          "prod_name":prodName,
          "prod_price":prodPrice,
          "prod_desc":prodDesc,
          "updated_at": DateTime.now()
        });

        return Response.json({'message':'Uppdate vendor data success', 'code':200, 'data': products},200);
      } catch (e) {
        return Response.json({'message':'Internal server error', 'code':500, 'data': e},500);
      }
     }

     Future<Response> destroy(int id) async {
      final products = await Products().query().where('prod_id', '=', id.toString()).first();

      if (products == null) {
        return Response.json({
          'message': 'Vendors Data Not Found',
          'code': 200,
          'data': products
        }, 200);
      }

      await Products().query().where('prod_id', '=', id).delete();
      
      return Response.json({
        'success': true,
        'message': 'Product Data Success to Delete',
        'data': products
      });
     }
}

final ProductController productController = ProductController();

