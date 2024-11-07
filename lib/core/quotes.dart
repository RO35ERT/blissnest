import 'dart:convert';

import 'package:blissnest/model/quote.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<Quote?> fetchTodayQuote() async {
    final url = Uri.parse('https://zenquotes.io/api/today');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return Quote.fromJson(data[0]);
      } else {
        print('Failed to fetch quote: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }
}
