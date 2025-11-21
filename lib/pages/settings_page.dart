import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/database_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _cityController = TextEditingController(text: 'Loja');
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = false;
  String? _message;

  Future<void> _searchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _message = 'Por favor ingresa una ciudad';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final weather = await _weatherService.getWeather(_cityController.text);
      await DatabaseService.instance.saveWeather(weather);

      setState(() {
        _message = '✅ Clima guardado: ${weather.cityName}';
        _isLoading = false;
      });

      // Mostrar SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guardado: ${weather.cityName}')),
        );
      }
    } catch (e) {
      setState(() {
        _message = '❌ Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Ciudad'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecciona el lugar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchWeather,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('GUARDAR', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.startsWith('✅') ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
