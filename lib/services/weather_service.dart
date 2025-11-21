import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = 'ec28e0d1651ede77271004887d50cec5';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(String cityName) async {
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=es');

    try {
      print('🌐 Llamando a la API: $url\n');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Respuesta recibida de la API:');
        print('Ciudad: ${data['name']}');
        print('Temperatura: ${data['main']['temp']}°C');
        print('Descripción: ${data['weather'][0]['description']}');
        print('');

        return Weather.fromJson(data);
      } else {
        throw Exception('Error al cargar datos del clima: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
