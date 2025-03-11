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
    final int maxRedirects = 3;
    Set<String> visitedUrls = {};
    String currentUrl = "${apiUrl}apps";

    try {
      for (
        int redirectCount = 0;
        redirectCount < maxRedirects;
        redirectCount++
      ) {
        if (visitedUrls.contains(currentUrl)) {
          throw Exception("Detected redirect loop at $currentUrl");
        }

        visitedUrls.add(currentUrl);
        log("Attempting GET request to: $currentUrl");

        final response = await dio.get(
          currentUrl,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => status != null && status < 500,
          ),
        );

        log("Status Code: ${response.statusCode}");

        if (response.statusCode == 200) {
          if (response.data is List) {
            List<dynamic> jsonList = response.data;
            return jsonList.map((json) => AppModel.fromJson(json)).toList();
          } else {
            throw Exception(
              "Invalid response format: expected a list but got ${response.data.runtimeType}",
            );
          }
        } else if (response.statusCode == 308) {
          String? redirectUrl;

          if (response.headers.map.containsKey('location') &&
              response.headers.map['location']?.isNotEmpty == true) {
            redirectUrl = response.headers.map['location']?.first;
          }

          if (redirectUrl == null || redirectUrl.isEmpty) {
            throw Exception("308 redirect without valid Location header");
          }

          // Ensure URL is absolute and properly formatted
          if (!redirectUrl.startsWith('https')) {
            redirectUrl = Uri.parse(apiUrl).resolve(redirectUrl).toString();
          }

          log("Redirecting to: $redirectUrl");

          if (redirectUrl == currentUrl) {
            throw Exception(
              "Server is redirecting to the same URL (redirect loop)",
            );
          }

          currentUrl = redirectUrl;
        } else {
          throw Exception(
            "Failed to load apps: Status code ${response.statusCode}",
          );
        }
      }

      throw Exception("Maximum number of redirects ($maxRedirects) exceeded");
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Error: $e");
    }
  }

  static Future<String> addApp(AppModel app) async {
    var headers = {'Content-Type': 'application/json'};
    final int maxRedirects = 3; // Maximum number of redirects to follow
    Set<String> visitedUrls =
        {}; // Track URLs we've already visited to detect loops
    String currentUrl = '$apiUrl/add-app';

    try {
      for (
        int redirectCount = 0;
        redirectCount < maxRedirects;
        redirectCount++
      ) {
        // Check if we've already visited this URL (redirect loop)
        if (visitedUrls.contains(currentUrl)) {
          return "Error: Detected redirect loop at $currentUrl";
        }

        visitedUrls.add(currentUrl);
        log("Attempting POST request to: $currentUrl");

        final response = await dio.post(
          currentUrl,
          options: Options(
            headers: headers,
            followRedirects: false,
            validateStatus: (status) => status != null && status < 500,
          ),
          data: jsonEncode(app.toJson()),
        );

        log("Status Code: ${response.statusCode}");
        log("Response Body: ${response.data}");

        if (response.statusCode == 200) {
          return "App added successfully";
        } else if (response.statusCode == 308) {
          // Try to get redirect URL from headers first
          String? redirectUrl;

          if (response.headers.map.containsKey('location') &&
              response.headers.map['location']?.isNotEmpty == true) {
            redirectUrl = response.headers.map['location']?.first;
          }

          if (redirectUrl == null || redirectUrl.isEmpty) {
            return "Error: 308 redirect without valid Location header";
          }

          // Ensure URL is absolute and properly formatted
          if (!redirectUrl.startsWith('https')) {
            redirectUrl = Uri.parse(apiUrl).resolve(redirectUrl).toString();
          }

          log("Redirecting to: $redirectUrl");

          // Check if we're being redirected to the same URL (loop)
          if (redirectUrl == currentUrl) {
            return "Error: Server is redirecting to the same URL (redirect loop)";
          }

          // If GET didn't succeed, try POST to the redirect URL
          log("Attempting POST request to redirect URL: $redirectUrl");
          final postResponse = await dio.post(
            redirectUrl,
            options: Options(
              headers: headers,
              followRedirects: false,
              validateStatus: (status) => status != null && status < 500,
            ),
            data: jsonEncode(app.toJson()),
          );

          log("POST Redirect Status: ${postResponse.statusCode}");
          log("POST Redirect Body: ${postResponse.data}");

          if (postResponse.statusCode == 200) {
            return "App added successfully (via POST redirect)";
          } else if (postResponse.statusCode == 308) {
            // Continue the redirect loop with the new URL
            currentUrl = redirectUrl;
          } else {
            return "Redirect request failed with status: ${postResponse.statusCode}";
          }
        } else {
          return "Request failed with status code: ${response.statusCode}";
        }
      }

      return "Error: Maximum number of redirects ($maxRedirects) exceeded";
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      return "Error: ${e.message}";
    } catch (e) {
      log("General Error: $e");
      return "Error: $e";
    }
  }

  static Future<String> updateAppVersion(AppModel app) async {
    var headers = {'Content-Type': 'application/json'};
    final int maxRedirects = 3; // Maximum number of redirects to follow
    Set<String> visitedUrls =
        {}; // Track URLs we've already visited to detect loops
    String currentUrl = "$apiUrl/${app.appId}/update-version";

    try {
      for (
        int redirectCount = 0;
        redirectCount < maxRedirects;
        redirectCount++
      ) {
        // Check if we've already visited this URL (redirect loop)
        if (visitedUrls.contains(currentUrl)) {
          return "Error: Detected redirect loop at $currentUrl";
        }

        visitedUrls.add(currentUrl);
        log("Attempting PUT request to: $currentUrl");

        final response = await dio.put(
          currentUrl,
          options: Options(
            headers: headers,
            followRedirects: false,
            validateStatus: (status) => status != null && status < 500,
          ),
          data: jsonEncode(app.toJson()),
        );

        log("Status Code: ${response.statusCode}");
        log("Response Body: ${response.data}");

        if (response.statusCode! < 300) {
          return "App version updated successfully";
        } else if (response.statusCode == 308) {
          // Try to get redirect URL from headers first
          String? redirectUrl;

          if (response.headers.map.containsKey('location') &&
              response.headers.map['location']?.isNotEmpty == true) {
            redirectUrl = response.headers.map['location']?.first;
          }

          if (redirectUrl == null || redirectUrl.isEmpty) {
            return "Error: 308 redirect without valid Location header";
          }

          // Make sure URL is absolute\
          if (!redirectUrl.startsWith('https')) {
            redirectUrl = Uri.parse(apiUrl).resolve(redirectUrl).toString();
          }

          // Check if we're being redirected to the same URL (loop)
          if (redirectUrl == currentUrl) {
            return "Error: Server is redirecting to the same URL (redirect loop)";
          }

          // If GET didn't succeed, try PUT to the redirect URL
          log("Attempting PUT request to redirect URL: $redirectUrl");
          final putResponse = await dio.put(
            redirectUrl,
            options: Options(
              headers: headers,
              followRedirects: false,
              validateStatus: (status) => status != null && status < 500,
            ),
            data: jsonEncode(app.toJson()),
          );

          log("PUT Redirect Status: ${putResponse.statusCode}");

          if (putResponse.statusCode! < 300) {
            return "App version updated successfully";
          } else if (putResponse.statusCode == 308) {
            // Continue the redirect loop with the new URL
            currentUrl = redirectUrl;
          } else {
            return "Redirect request failed with status: ${putResponse.statusCode}";
          }
        } else {
          return "Request failed with status code: ${response.statusCode}";
        }
      }

      return "Error: Maximum number of redirects ($maxRedirects) exceeded";
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      return "Error: ${e.message}";
    } catch (e) {
      log("General Error: $e");
      return "Error: $e";
    }
  }
}
