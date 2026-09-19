
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {

  static String get baseUrl => dotenv.get('BASE_URL');
  static String get register => '$baseUrl/users/request';
  static String get registerOtpVerify => '$baseUrl/users/create';
  static String get login => '$baseUrl/auth/login';
  static String get resetPassword => '$baseUrl/auth/send-otp';
  static String get resetPasswordVerifyOtp => '$baseUrl/auth/verify-otp';
  static String get resetNewPassword => '$baseUrl/auth/reset-password';


}