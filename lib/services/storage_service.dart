import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _historyKey = 'weather_history';

  Future<void> saveWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    history.insert(0, json.encode(weather.toJson()));

    // Limitar a los últimos 20 registros
    if (history.length > 20) {
      history = history.sublist(0, 20);
    }

    await prefs.setStringList(_historyKey, history);
  }

  Future<List<Weather>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    return history
        .map((item) => Weather.fromStoredJson(json.decode(item)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
