import 'package:flutter/foundation.dart';
import 'package:flutter_assiment/models/giveaway_detail.dart';
import 'package:flutter_assiment/models/giveaway_model.dart';
import 'package:http/http.dart' as http;

class GiveawayService {
  final _baseUrl = 'https://www.gamerpower.com/api';

  Future<List<GiveawayModel>> fetchGieaWay() async {
    final url = "$_baseUrl/giveaways";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final model = await compute(giveawayModelFromJson, response.body);
        return model;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load meals: $e');
    }
  }

  Future<GiweawayDetail> get(int id) async {
    final url = "$_baseUrl/giveaway?id=$id";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final model = await compute(giweawayDetailFromJson, response.body);
        return model;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load meal detail: $e');
    }
  }
}
