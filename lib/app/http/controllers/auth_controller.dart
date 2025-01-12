import 'dart:convert';
import '../models/user_model.dart';
import '../services/jwt_service.dart';
import '../utils/hash_util.dart';
import 'package:vania/vania.dart';

class AuthController {
  // Register
  static Future<void> register(Context ctx) async {
    final body = await ctx.body();
    final data = jsonDecode(body);

    final username = data['username'];
    final password = data['password'];

    // Check if user already exists
    final existingUser = await UserModel.findByUsername(username);
    if (existingUser != null) {
      ctx.response.statusCode = 400;
      ctx.response.json({'message': 'User already exists'});
      return;
    }

    // Hash password and save user
    final hashedPassword = HashUtil.hashPassword(password);
    final newUser = UserModel(username: username, password: hashedPassword);
    await newUser.save();

    ctx.response.json({'message': 'User registered successfully'});
  }

  // Login
  static Future<void> login(Context ctx) async {
    final body = await ctx.body();
    final data = jsonDecode(body);

    final username = data['username'];
    final password = data['password'];

    // Find user by username
    final user = await user_model.findByUsername(username);
    if (user == null) {
      ctx.response.statusCode = 400;
      ctx.response.json({'message': 'Invalid username or password'});
      return;
    }

    // Verify password
    if (!HashUtil.verifyPassword(password, user.password)) {
      ctx.response.statusCode = 401;
      ctx.response.json({'message': 'Invalid username or password'});
      return;
    }

    // Generate JWT token
    final token = JwtService.generateToken({'id': user.id});

    ctx.response.json({'message': 'Login successful', 'token': token});
  }
}
