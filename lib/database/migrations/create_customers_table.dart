import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('customers', () {
      char('cust_id', length: 5, unique: true);
      primary('cust_id');
      string('name', length: 50);
      string('adress', length: 50);
      string('city', length: 20);
      string('state', length: 10);
      string('zip', length: 7);
      string('country', length: 25);
      string('telephone', length: 15);
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customers');
  }
}
