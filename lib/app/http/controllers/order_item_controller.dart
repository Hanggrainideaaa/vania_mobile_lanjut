import 'package:tugas_api/app/models/orders.dart';
import 'package:tugas_api/app/models/orders_items.dart';
import 'package:tugas_api/app/models/products.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {

     Future<Response> index() async {
      final orderItems = await OrdersItems().query()
      .join("orders", "orders.order_num", "=", "orderitems.order_num")
      .join("customers", "customers.cust_id", "=", "orders.cust_id")
      .leftJoin("products", "products.prod_id", "=", "orderitems.prod_id")
      .select([
        "orderitems.order_items",
        "orderitems.quantity",
        "orderitems.size",
        "products.prod_name as product_name",
        "products.prod_price as product_price",
        "products.prod_desc as product_description",
        "orders.order_date as order_date",
        "customers.name as customer_name",
        "customers.address as customer_address",
        "customers.city as customer_city",
        "customers.country as customer_country",
        "customers.telp as customer_telp"
      ]).get();

      return Response.json({"message": "success", "code":200, "data":orderItems});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
      print(request.all());
      try {
        request.validate({
          'order_items': 'required|numeric|max_length:11',
          'order_num': 'required|numeric|max_length:11',
          'prod_id': 'required|string|max_length:5',
          'quantity': 'required|numeric|max_length:11',
          'sized': 'required|numeric|max_length:11'
        });

        final orderItem = request.input('order_item');
        final orderNum = request.input('order_num');
        final prodId = request.input('prod_id');
        final quantity = request.input('quantity');
        final sized = request.input('sized');

        final order = await Orders().query().where('order_num', '=', request.input('order_num').toString()).first();
        final product = await Products().query().where('prod_id', '=', request.input('prod_id').toString()).first();

        if (product ==null) {
          return Response.json({'success': false, 'message': 'Product not found'}, 404);
        } else if (order == null) {
          return Response.json({'success': false, 'message': 'Order not found'}, 404);
        }

        var orderItems = await OrdersItems().query().where('order_item', '=', orderItem).first();
        if (orderItems != null) {
          return Response.json({
            "message": "Data already exist",
            "code": 409,
          });
        }

        final orders = await OrdersItems().query().insert({
          "order_items": orderItem,
          "order_num":orderNum,
          "prod_id": prodId,
          "quantity": quantity,
          "sized":sized,
          "created_at": DateTime.now(),
          "updated_at": DateTime.now()
        });

        return Response.json({
          "message": "Create Orders Item Success",
          "code": 201,
          "data": orders
        }, 201);
      } catch (e) {
        if (e is ValidationException) {
          var errorMessage = e.message;
          return Response.json({"message": errorMessage, "code":401},401);
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
      final orderItems = await OrdersItems().query().where('oder_items', '=', id.toString()).first();

      try {
        request.validate({
          'order_items': 'required|numeric|max_length:11',
          'order_num': 'required|numeric|max_length:11',
          'prod_id': 'required|string|max_length:5',
          'quantity': 'required|numeric|max_length:11',
          'sized': 'required|numeric|max_length:11'
        });

        final orderItem = request.input('order_item');
        final orderNum = request.input('order_num');
        final prodId = request.input('prod_id');
        final quantity = request.input('quantity');
        final sized = request.input('sized');

        final order = await Orders().query().where('order_num', '=', request.input('order_num').toString()).first();
        final product = await Products().query().where('prod_id', '=', request.input('prod_id').toString()).first();

        if (product ==null) {
          return Response.json({'success': false, 'message': 'Product not found'}, 404);
        } else if (order == null) {
          return Response.json({'success': false, 'message': 'Order not found'}, 404);
        }

        await OrdersItems().query().where('order_item', '=', id.toString()).update({
          "order_items": orderItem,
          "order_num":orderNum,
          "prod_id": prodId,
          "quantity": quantity,
          "sized":sized,
          "updated_at": DateTime.now()
        });

        return Response.json({
          "message": "Update Orders Data Success",
          "code": 200,
          "data": orderItems
        }, 200);
      } catch (e) {
        return Response.json({
          "message": "Internal server error",
          "code": 500,
        }, 500);
      }
     }

     Future<Response> destroy(int id) async {
      final products = await OrdersItems().query().where('order_item', '=', id.toString()).first();
      
      if (products == null) {
        return Response.json({
          "message": "Orders Data Not Found",
          "code": 200,
          "data": products
        }, 200);
      }

      await OrdersItems().query().where('order_item', '=', id).delete();
      
      return Response.json({
        "success": true,
        "message": "Orders Data Not Found",
        "data": products
      });
     }
}

final OrderItemController orderItemController = OrderItemController();

