import 'package:tugas_api/app/http/controllers/customers_controller.dart';
import 'package:tugas_api/app/http/controllers/order_controller.dart';
import 'package:tugas_api/app/http/controllers/order_item_controller.dart';
import 'package:tugas_api/app/http/controllers/product_controller.dart';
import 'package:tugas_api/app/http/controllers/productnote_controller.dart';
import 'package:tugas_api/app/http/controllers/vendor_controller.dart';
import 'package:vania/vania.dart';
// import 'package:tugas_api/app/http/controllers/home_controller.dart';
// import 'package:tugas_api/app/http/middleware/authenticate.dart';
// import 'package:tugas_api/app/http/middleware/home_middleware.dart';
// import 'package:tugas_api/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');
    Router.get("/customer", customersController.index);

    Router.resource("/customers", customersController);
    Router.resource("/orders", orderController);
    Router.resource("/vendors", vendorController);
    Router.resource("/products", productController);
    Router.resource("/productnote", productnoteController);
    Router.resource("/orderitem", orderItemController);

    // Router.get("/home", homeController.index);

    // Router.get("/hello-world", () {
    //   return Response.html('Hello World');
    // }).middleware([HomeMiddleware()]);

    // // Return error code 400
    // Router.get('wrong-request',
    //         () => Response.json({'message': 'Hi wrong request'}))
    //     .middleware([ErrorResponseMiddleware()]);

    // // Return Authenticated user data
    // Router.get("/user", () {
    //   return Response.json(Auth().user());
    // }).middleware([AuthenticateMiddleware()]);
  }
}
