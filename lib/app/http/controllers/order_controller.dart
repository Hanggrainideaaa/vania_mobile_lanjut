import 'package:tugas_api/app/models/customers.dart';
import 'package:tugas_api/app/models/orders.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {

     Future<Response> index() async {
      final orderList = await Orders().query().join("customers", "customers.cust_id", "=", "orders.cust_id").select([
        "orders.order_num",
        "orders.order_date",
        "customers.name as customers_name",
        "customers.address as customers_address",
        "customers.city as customers_city",
        "customers.country as customers_country",
        "customers.telephone as cutomers_telp"
      ]).get();

      return Response.json({"message":"success", "code":200, "data": orderList});
     }

     Future<Response> create() async {
      return Response.json({});
     }

     Future<Response> store(Request request) async {
      try {
        request.validate({
          'order_num': 'required|numeric|max_lenght:11',
          'order_date': 'required|date',
          'cust_id': 'required|string',
        });
        final orderNum = request.input('order_num');
        final orderDate = request.input('order_date');
        final custId = request.input('cust_id');

        final customers = await Customers().query().where('cust_id', '=', request.input('cust_id').toString()).first();

        if (customers == null) {
          return Response.json({'sucsess': false, 'massage': 'Customers not found'},400);
        }

        var ordernum = await Orders().query().where('order_num', '=', orderNum).first();
        if (ordernum != null) {
          return Response.json({"massage": "Data already exist", "code": 409,});
        }

        final orders = await Orders().query().insert({
          "order_num": orderNum,
          "order_date":orderDate,
          "cust_id":custId,
          "created_at": DateTime.now(),
          "update_at": DateTime.now()
        });

        return Response.json({"message": "Create Orders Success", "code": 201, "data": orders},201);

      } catch (e) {
        if (e is ValidationException) {
          var  errorMessage = e.message;
          return Response.json({"message": errorMessage, "Code": 401}, 401);
        }else {
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
      final orders = await Orders().query().where('order_num', '=', id.toString()).first();
      try {
        request.validate({
          'order_num': 'required|numeric|max_lenght:11',
          'order_date': 'required|date',
          'cust_id': 'required|string',
        });
        final orderNum = request.input('order_num');
        final orderDate = request.input('order_date');
        final custId = request.input('cust_id');

        final customers = await Customers().query().where('cust_id', '=', request.input('cust_id').toString()).first();

        if (customers == null) {
          return Response.json({'sucsess': false, 'massage': 'Customers not found'},404);
        }

        await Orders().query().where('order_num', '=', id.toString()).update({
          "order_num": orderNum,
          "order_date":orderDate,
          "cust_id":custId,
          "update_at": DateTime.now()
        });

        return Response.json({"message": "Update Orders Data Success", "code": 200, "data": orders},200);
      } catch (e) {
        return Response.json({
          "message": "Internal server error",
          "code": 500,
        }, 500);
      }
     }

     Future<Response> destroy(int id) async {
      final order = await Orders().query().where('order_num', '=', id.toString()).first();

      if (order == null) {
        return Response.json({"message": "Orders Data Not Found", "code": 200, "data": order},200);
      }

       await Orders().query().where('order_num', '=', id).delete();

       return Response.json({'success': true, "message": "Delet Orders Data Success", "data": order});
     }
}

final OrderController orderController = OrderController();

