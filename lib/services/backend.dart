import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:upsync/model/api_model.dart';

class Backend {
  //get the api url from the .env file
  static final String apiUrl = dotenv.env['API_URL'] ?? '';
  static final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        return status != null && (status < 300 || status == 308);
      },
    ),
  );

  static Future<List<AppModel>> fetchApps() async {
    final response = await dio.get("$apiUrl/apps");
    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => AppModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load apps");
    }
  }

  static Future<String> addApp(AppModel app) async {
    var headers = {'Content-Type': 'application/json'};

    Uri uri = Uri.parse('$apiUrl/add-app');

    final response = await dio.post(
      uri.toString(),
      options: Options(headers: headers),
      data: jsonEncode(app.toJson()),
    );

    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 308) {
      // Get the redirection URL
      String? redirectUrl = response.headers['location']?.first;

      if (redirectUrl != null) {
        // Ensure we use the full URL if it's a relative path
        Uri finalUri =
            redirectUrl.startsWith('http')
                ? Uri.parse(redirectUrl)
                : Uri.parse('$apiUrl$redirectUrl');

        log("Redirecting to: $finalUri");

        final redirectedResponse = await dio.post(
          finalUri.toString(),
          options: Options(headers: headers),
          data: jsonEncode(app.toJson()),
        );

        log("Final Status Code: ${redirectedResponse.statusCode}");
        log("Final Response: ${redirectedResponse.data}");

        return redirectedResponse.statusCode == 200
            ? redirectedResponse.data
            : "Redirection failed: ${redirectedResponse.statusCode}";
      } else {
        log("Redirection URL not found");
        return "Redirection URL not found";
      }
    } else {
      log("Failed to add app: ${response.statusMessage ?? ''}");
      return "Failed to add app: ${response.statusMessage ?? ''}";
    }
  }

  static Future<void> updateAppVersion(AppModel app) async {
    await dio.put(
      "$apiUrl/${app.appId}/update-version",
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode(app.toJson()),
    );
  }
}
