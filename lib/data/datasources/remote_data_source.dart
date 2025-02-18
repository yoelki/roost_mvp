import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/app_model.dart';

class RemoteDataSource {
  final String apiUrl = "https://api.example.com/apps";

  Future<List<AppModel>> getApps() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => AppModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load apps");
    }
  }
}
