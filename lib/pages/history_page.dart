import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/database_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Weather> _allWeather = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllWeather();
  }

  Future<void> _loadAllWeather() async {
    final all = await DatabaseService.instance.getAllWeather();
    setState(() {
      _allWeather = all;
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar todo el historial?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.instance.clearHistory();
      _loadAllWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Completo'),
        centerTitle: true,
        actions: [
          if (_allWeather.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allWeather.isEmpty
          ? const Center(child: Text('No hay registros guardados'))
          : ListView.builder(
        itemCount: _allWeather.length,
        itemBuilder: (context, index) {
          final weather = _allWeather[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: ListTile(
              title: Text(weather.cityName),
              subtitle: Text(
                '${weather.temperature.toStringAsFixed(1)}°C - ${weather.description}',
              ),
              trailing: Text(
                '${weather.timestamp.day}/${weather.timestamp.month}/${weather.timestamp.year}\n${weather.timestamp.hour}:${weather.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
            ),
          );
        },
      ),
    );
  }
}
