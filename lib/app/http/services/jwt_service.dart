import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  static const _secret = 'your_jwt_secret_key';

  // Generate JWT token
  static String generateToken(Map<String, dynamic> payload) {
    final jwt = JWT(payload);
    return jwt.sign(SecretKey(_secret), expiresIn: const Duration(hours: 1));
  }

  // Verify JWT token
  static JWT? verifyToken(String token) {
    try {
      return JWT.verify(token, SecretKey(_secret));
    } catch (e) {
      return null;
    }
  }
}
