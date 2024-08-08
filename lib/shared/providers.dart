import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interview_flutter/services/location_service.dart';
import 'package:interview_flutter/services/preferences_service.dart';

//Los providers permiten el acceso global a los servicios y facilita el desacoplamiento.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
