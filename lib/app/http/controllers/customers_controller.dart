import 'package:tugas_api/app/models/customers.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';


class CustomersController extends Controller {

     Future<Response> index() async {
      final customerList = await Customers().query().get();
        return Response.json(
          {'message':'sucess', 'code': 200, 'data': customerList});
     }

     Future<Response> create() async {
      return Response.json({});
     }

     Future<Response> store(Request request) async {
      try {
        request.validate({
          'cust_id': 'required|maxleght:5',
          'name': 'required|string|max_length:50',
          'adress': 'required|string|max_length:50',
          'city': 'required|string|max_length:20',
          'state': 'required|string|max_length:10',
          'zip': 'required|string|max_length:7',
          'country': 'required|string|max_length:25',
          'telephone': 'required|string|max_length:15',
        });
        final custId = request.input('cust_id');
        final name = request.input('name');
        final adress  = request.input('adress');
        final  city = request.input('city');
        final state = request.input('state');
        final zip = request.input('zip');
        final country = request.input('country');
        final telephone = request.input('telephone');
        var custID = await Customers().query().where('cust_id', '=', custId).first();
        if (custID != null) {
          return Response.json({
            "message": "Data alredy exist",
            "code": 409,
          });
        }

        final customers = await Customers().query().insert({
          "cust_id": custId,
          "name" : name,
          "adress" : adress,
          "city" : city,
          "state" : state,
          "zip" : zip,
          "country": country,
          "telephone" :telephone,
          "created_at" : DateTime.now(),
          // "update_at" : DateTime.now()
        });

        return Response.json({
          "massage": "Create customers success",
          "code": 201,
          "data":customers
        }, 201);
      } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({"massage": errorMessage, "Code": 401}, 401);
      } else {
        return Response.json(
          {"message": "Internal server error", "code":500, "data":e}, 500
        );
      }
     }  
    } 

     Future<Response> show(int id) async {
      final customer = await Customers().query().where('cust_id', '=', id.toString()).first();

      if (customer == null) {
        return Response.json({
          "message": "Customer data not found",
          "code":404,
        }, 404);
      }
      
      return Response.json({
        'message': 'Customer data founded',
        'code': 200,
        'data':customer
      });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
      final customers = await Customers().query().where('cust_id', '=', id.toString()).first();

      try {
        request.validate({
          'cust_id': 'required|maxleght:5',
          'name': 'required|string|max_length:50',
          'adress': 'required|string|max_length:50',
          'city': 'required|string|max_length:20',
          'state': 'required|string|max_length:10',
          'zip': 'required|string|max_length:7',
          'country': 'required|string|max_length:25',
          'telephone': 'required|string|max_length:15',
        });
        final custId = request.input('cust_id');
        final name = request.input('name');
        final adress  = request.input('adress');
        final  city = request.input('city');
        final state = request.input('state');
        final zip = request.input('zip');
        final country = request.input('country');
        final telephone = request.input('telephone');

        await Customers().query().where('cust_id', '=', id.toString()).update({
          "cust_id": custId,
          "name" : name,
          "adress" : adress,
          "city" : city,
          "state" : state,
          "zip" : zip,
          "country": country,
          "telephone" :telephone,
          "update_at" : DateTime.now()
        });

        return Response.json({
          "massage": "Update customers success",
          "code": 200,
          "data":customers
        }, 200);
      } catch (e) {
        return Response.json({
          "message": "Internal Server Error",
          "code": 500,
        }, 500);
      }
     }

     Future<Response> destroy(int id) async {
      final customers = await Customers().query().where('cust_id', '=', id.toString()).first();

      if (customers == null) {
        return Response.json({
          'message': "Customer data not found",
          'code': 200,
          'data':customers
        }, 200);
      }

      await Customers().query().where('cust_id', '=', id).delete();

      return Response.json({
        'success': true,
        'massage': 'Success to delete data',
        'data':customers
      });
     }
}

final CustomersController customersController = CustomersController();

