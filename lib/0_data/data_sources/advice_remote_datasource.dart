import 'dart:convert';
import 'package:advicer/0_data/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/advice_model.dart';

abstract class AdviceRemoteDatasource {
  Future<AdviceModel> getRandomAdviceFromAPI();
}

class AdviceRemoteDatasourceImpl implements AdviceRemoteDatasource {
  final client = http.Client();
  @override
  Future<AdviceModel> getRandomAdviceFromAPI() async {
    final response = await client.get(
        Uri.parse('https://api.flutter-community.com/api/v1/advice'),
        headers: {'content-type': 'application/json'});
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final responseBody = json.decode(response.body);
      return AdviceModel.fromJson(responseBody);
    }
  }
}
