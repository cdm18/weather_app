import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? _currentWeather;
  List<Weather> _recentWeather = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentWeather();
  }

  Future<void> _loadRecentWeather() async {
    final recent = await DatabaseService.instance.getRecentWeather(limit: 5);
    setState(() {
      _recentWeather = recent;
      if (recent.isNotEmpty) {
        _currentWeather = recent.first;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del Tiempo'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Clima actual
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade100,
              child: _currentWeather == null
                  ? const Center(
                child: Text('No hay datos\nVe a Settings para buscar'),
              )
                  : _buildCurrentWeather(),
            ),
          ),

          // Registros recientes
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Registros Recientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _recentWeather.isEmpty
                        ? const Center(child: Text('No hay registros'))
                        : ListView.builder(
                      itemCount: _recentWeather.length,
                      itemBuilder: (context, index) {
                        final weather = _recentWeather[index];
                        return ListTile(
                          title: Text(weather.cityName),
                          subtitle: Text(
                            '${weather.temperature.toStringAsFixed(1)}°C - ${weather.description}',
                          ),
                          trailing: Text(
                            '${weather.timestamp.day}/${weather.timestamp.month}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _currentWeather!.cityName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '${_currentWeather!.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 48),
        ),
        Text(
          _currentWeather!.description,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
