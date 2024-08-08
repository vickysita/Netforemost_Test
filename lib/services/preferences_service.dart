import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Guarda la ciudad y descripción en SharedPreferences
  Future<void> saveLocation(String city, String description) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');
    if (savedLocations == null) {
      savedLocations = [];
    }
    savedLocations.add('$city|$description');
    await prefs.setStringList('locations', savedLocations);
  }

  // Recupera las ciudades y descripciones guardadas desde SharedPreferences
  Future<List<Map<String, String>>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');
    if (savedLocations == null) {
      return [];
    }
    return savedLocations.map((location) {
      final parts = location.split('|');
      return {'city': parts[0], 'description': parts[1]};
    }).toList();
  }
}
