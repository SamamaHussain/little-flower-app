class Weather {
  final String locationName;
  final String region;
  final String country;
  final double tempC;
  final String conditionText;
  final String conditionIcon;
  final int isDay;

  Weather({
    required this.locationName,
    required this.region,
    required this.country,
    required this.tempC,
    required this.conditionText,
    required this.conditionIcon,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
      tempC: json['current']['temp_c'].toDouble(),
      conditionText: json['current']['condition']['text'],
      conditionIcon: json['current']['condition']['icon'],
      isDay: json['current']['is_day'],
    );
  }
}
