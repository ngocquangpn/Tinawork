import 'package:http/http.dart';
import 'package:tinawork/src/core/api.dart';
import 'package:tuple/tuple.dart';

class ApiForgotPassword {
  static sendEmail(String email) async {
     Tuple2<Response, bool> result = await CoreApi.post('/auth/mail-otp', body: {'email': email});
    return result;
  }
  
  static sendVerifyCode(String email, String code) async {
    Tuple2<Response, bool> result = await CoreApi.post('/auth/verify-otp', body: {'otpCode': code, 'email': email});
    return result;
  }
  
  static changePassword(String email, String otpCode, String newPassword) async {
    Tuple2<Response, bool> result = await CoreApi.post('/auth/change-password-by-otp', body: {'email': email, 'otpCode': otpCode, 'newPassword': newPassword});
    return result;
  }
}