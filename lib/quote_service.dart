
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote_model.dart';

class QuoteService {
  final String baseUrl = 'https://dummyjson.com/quotes/random';

  // Stores the quote in memory
  Quote? cachedQuote;

  Future<Quote> fetchQuote({bool forceRefresh = false}) async {
    // Return cached quote if available
    if (cachedQuote != null && !forceRefresh) {
      return cachedQuote!;
    }

    try {
      // Make API request with a 5-second timeout
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Convert JSON response into a Dart object
        final data = jsonDecode(response.body);

        final quote = Quote.fromJson(data);

        // Save quote in cache
        cachedQuote = quote;

        return quote;
      } else {
        throw Exception('Failed to load quote');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Try again.');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
