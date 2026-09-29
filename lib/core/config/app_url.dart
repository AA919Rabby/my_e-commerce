
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {

  static String get baseUrl => dotenv.get('BASE_URL');
  static String get register => '$baseUrl/api/v1/users/register';
  static String get login => '$baseUrl/api/v1/users/login';
  static String get recoveryPassword => '$baseUrl/api/v1/users/recover_password';
  static String get recoveryOtpVerify => '$baseUrl/api/v1/users/recovery_otp_verify';
  static String get recoveryNewPassword => '$baseUrl/api/v1/users/recover_new_password';
  static String get getProducts => '$baseUrl/api/v1/services';
  static String get getCategories => '$baseUrl/api/v1/services/categories';
  static String get notification => '$baseUrl/api/v1/notifications';
  static String get makeServices => '$baseUrl/api/v1/services/order';
  static String get pendingServices => '$baseUrl/api/v1/services/order/history';
  static String cancelServices(String orderId) => '$baseUrl/api/v1/services/order/$orderId/cancel';
  static String get makePayment => '$baseUrl/api/v1/payment/initiate';
  //static String get addReview => '$baseUrl/api/v1/services/reviews';
  //static String get getReview => '$baseUrl/api/v1/services/1/reviews';
  static String get addReview => '$baseUrl/api/v1/services/reviews';
  static String  getReview(String serviceId) => '$baseUrl/api/v1/services/$serviceId/reviews';
  static String completeServices(String orderId) => '$baseUrl/api/v1/services/order/$orderId/complete';

 //websockets
  static String get servicesWs => '${baseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')}/api/v1/services/ws';
  static String get slotsWs => '${baseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')}/api/v1/slots/ws';

  /// /
  //static String get registerOtpVerify => '$baseUrl/users/create';
  static String get resetPassword => '$baseUrl/auth/send-otp';
  static String get resetPasswordVerifyOtp => '$baseUrl/auth/verify-otp';
  static String get resetNewPassword => '$baseUrl/auth/reset-password';
  //static String get getCategories => '$baseUrl/products/categories';
  //static String get getProducts => '$baseUrl/products';
  static String get updateProfile => '$baseUrl/auth/set-profile';


}