import 'package:tugas_api/app/models/product_notes.dart';
import 'package:tugas_api/app/models/products.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';


class ProductnoteController extends Controller {

     Future<Response> index() async {
      final producNote = await ProductNotes().query().get();

      return Response.json({'message':'success', 'code':200, 'data': producNote});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
      try {
        request.validate({
          'note_id' : 'required|max_length:5',
          'prod_id' : 'required|string|max_length:10',
          'note_date' : 'requaired|date',
          'note_text' : 'requaired|string',
        });

        final noteId = request.input('note_id');
        final prodId = request.input('prod_id');
        final noteDate = request.input('note_date');
        final noteText = request.input('note_text');

        final products = await Products().query().where('prod_id', '=', request.input('prod_id').toString()).first();

        if (products ==null) {
          return Response.json({'success': false, 'message': 'Products not found'}, 404);
        }

        var noteID = await ProductNotes().query().where('note_id', '=', prodId).first();

        if (noteID != null) {
          return Response.json({
            "message" : "Data already exist",
            "code": 409,
          });
        }

        final notes = await ProductNotes().query().insert({
          "note_id" : noteId,
          "prod_id": prodId,
          "note_date": noteDate,
          "note_text":noteText,
          "created_at": DateTime.now(),
          "updated_at": DateTime.now()
        });

        return Response.json({
          'message':'Create vendor success', 
          'code':201, 
          'data':notes
        });
      } catch (e) {
        if (e is ValidationException) {
          var errorMessage = e.message;
          return Response.json({"message": errorMessage, "Code": 401}, 401);
        } else {
          return Response.json({"message": "Internal Server error", "code": 500, "data": e}, 500);
        }
      }
     }

     Future<Response> show(int id) async {
          return Response.json({});
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
      final notes = await ProductNotes().query().where('note_id', '=', id,toString()).first();

      try {
        request.validate({
          'note_id' : 'required|max_length:5',
          'prod_id' : 'required|string|max_length:10',
          'note_date' : 'requaired|date',
          'note_text' : 'requaired|string',
        });

        final noteId = request.input('note_id');
        final prodId = request.input('prod_id');
        final noteDate = request.input('note_date');
        final noteText = request.input('note_text');

        final prodID = await ProductNotes().query().where('prod_id', '=', request.input('prod_id').toString()).first();

        if (prodID ==null) {
          return Response.json({'success': false, 'message': 'Vendor not found'}, 404);
        }

        await ProductNotes().query().where('note_id', '=', id.toString()).update({
          "note_id" : noteId,
          "prod_id": prodId,
          "note_date": noteDate,
          "note_text":noteText,
          "updated_at": DateTime.now()
        });

        return Response.json({"message": "Update Notes Data Success", "code": 200, "data": notes},200);
      } catch (e) {
        return Response.json({
          "message": "Internal Server Error",
          "code": 500,
        }, 500);
      } 
     }

     Future<Response> destroy(int id) async {
      final products = await ProductNotes().query().where('note_id', '=', id.toString()).first();

      if (products == null) {
        return Response.json({
          'message': 'Products not found',
          'code': 200,
          'data': products
        }, 200);
      }

      await ProductNotes().query().where('note_id', '=', id).delete();

      return Response.json({
        'success': true,
        'message': 'Data Notes Berhasil Dihapus',
        'data': products
      });
     }
}

final ProductnoteController productnoteController = ProductnoteController();

