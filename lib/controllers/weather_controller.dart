import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:little_flower_app/models/weather_model.dart';
import 'package:little_flower_app/services/weather_services.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();

  // Observable variables
  var isLoading = false.obs;
  var weather = Rxn<Weather>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeatherByLocation();
  }

  // Check and request location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = 'Location services are disabled.';
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Location permissions are denied';
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value = 'Location permissions are permanently denied';
      return false;
    }

    return true;
  }

  // Get current position and fetch weather
  Future<void> fetchWeatherByLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check location permission
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        isLoading.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch weather data
      final weatherData = await _weatherService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (weatherData != null) {
        weather.value = weatherData;
      } else {
        errorMessage.value = 'Failed to fetch weather data';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    await fetchWeatherByLocation();
  }
}
