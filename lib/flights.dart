import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchFlights() async {
  final response = await http
      .get(Uri.parse('https://665d70e6e88051d604069591.mockapi.io/flights'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load flights');
  }
}

Future<List<String>> fetchUniqueOrigins() async {
  final flights = await fetchFlights();
  final origins =
      flights.map<String>((flight) => flight['origin']).toSet().toList();
  return origins;
}

Future<List<String>> fetchUniqueDestinations(String origin) async {
  final flights = await fetchFlights();
  final destinations = flights
      .where((flight) => flight['origin'] == origin)
      .map<String>((flight) => flight['destination'])
      .toSet()
      .toList();
  return destinations;
}
