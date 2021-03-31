import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinawork/src/config/index.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tuple/tuple.dart';

class CoreApi {
  static final _host = Config.HOST;
  static Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return token;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    return headers;
  }

  static Uri _getUri(String fullPath, {Map<String, String> params}) {
    if (Config.REQUEST_METHOD == 'http') {
      final uri = Uri.http(_host, fullPath, params);
      return uri;
    }
    else if (Config.REQUEST_METHOD == 'https') {
      final uri = Uri.https(_host, fullPath, params);
      return uri;
    }
    else {
      return new Uri();
    }
  }

  static String _getFullPath(String path) {
    if (Config.ROOT_API != '' && Config.ROOT_API != null) {
      return Config.ROOT_API + path;
    }
    else {
      return path;
    }
  }

  static checkConnectivity() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.mobile || connect == ConnectivityResult.wifi) return true;
    else return false;
  }

  static Future<Tuple2<http.Response, bool>> get(String path, {Map<String, String> params}) async {
    final headers = await _getHeaders();
    bool checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath, params: params);
    
    try {
      http.Response response = await http.get(
          uri,
          headers: headers
      ).timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch(e) {
      checkConnect = false;
      return new Tuple2(null, checkConnect);
    }
  }

  static Future<Tuple2<http.Response, bool>> post(String path, {Map<String, String> body}) async {
    final headers = await _getHeaders();
    final checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath);
    
    try {
      http.Response response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body)
      ).timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch (e) {
      return new Tuple2(null, false);
    }
  }

  static Future<Tuple2<http.Response, bool>> put(String path, {Map<String, String> body}) async {
    final headers = await _getHeaders();
    final checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath);

    try {
      http.Response response = await http.put(
          uri,
          headers: headers,
          body: jsonEncode(body)
      ).timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch (e) {
      return new Tuple2(null, false);
    }
  }

  static Future<Tuple2<http.Response, bool>> patch(String path, {Map<String, String> body}) async {
    final headers = await _getHeaders();
    final checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath);

    try {
      http.Response response = await http.patch(
          uri,
          headers: headers,
          body: jsonEncode(body)
      ).timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch (e) {
      return new Tuple2(null, false);
    }
  }

  static Future<Tuple2<http.Response, bool>> delete(String path, {Map<String, String> body}) async {
    final headers = await _getHeaders();
    final checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath);

    try {
      http.Response response = await http.delete(
          uri,
          headers: headers
      ).timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch (e) {
      return new Tuple2(null, false);
    }
  }

  static Future<Tuple2<http.StreamedResponse, bool>> uploadFile(
      String path,
      File file,
      String fileName,
      Map<String,String> fields,
      String type,
      String subType
      ) async {
    final headers = await _getHeaders();
    final checkConnect = await checkConnectivity();
    String fullPath = _getFullPath(path);
    final uri = _getUri(fullPath);
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(fields);
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: fileName,
      contentType: MediaType(type, subType)
    ));

    try {
      var response = await request.send().timeout(const Duration(seconds: Config.SET_TIMEOUT));
      return new Tuple2(response, checkConnect);
    }
    on TimeoutException catch (e) {
      return new Tuple2(null, false);
    }
  }
}