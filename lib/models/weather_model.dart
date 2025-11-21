class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final DateTime timestamp;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.timestamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'icon': icon,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Weather.fromStoredJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'],
      temperature: json['temperature'],
      description: json['description'],
      icon: json['icon'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
