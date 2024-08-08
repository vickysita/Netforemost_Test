import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interview_flutter/pages/locations/model/city.dart';
import 'package:flutter/services.dart';
import 'package:interview_flutter/services/preferences_service.dart';

class AddNewLocationPage extends ConsumerStatefulWidget {
  const AddNewLocationPage({super.key});

  @override
  ConsumerState<AddNewLocationPage> createState() => AddNewLocationForm();
}

class AddNewLocationForm extends ConsumerState<AddNewLocationPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  String _query = '';
  List<City> _cities = [];
  List<City> _filteredCities = [];
  final PreferencesService _preferencesService = PreferencesService();
  bool _isCitySelected = false;
  bool _isDescriptionFilled = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final cities = await loadCities();
    setState(() {
      _cities = cities;
    });
  }

  void _onCityChanged(String value) {
    setState(() {
      _query = value;
      _filteredCities = _cities
          .where(
              (city) => city.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
      _isCitySelected = _query.isNotEmpty &&
          _filteredCities.any((city) => city.name == _query);
    });
  }

  void _onDescriptionChanged(String value) {
    setState(() {
      _isDescriptionFilled = value.isNotEmpty;
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _cityFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Add City',
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _controller.clear();
                                    _query = '';
                                    _filteredCities = [];
                                    _isCitySelected = false;
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: _onCityChanged,
                      onEditingComplete: _dismissKeyboard,
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _filteredCities.isNotEmpty ? 200 : 20,
                  child: ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      return ListTile(
                        title: Text(city.name),
                        subtitle: Text(city.country),
                        onTap: () {
                          setState(() {
                            _controller.text = city.name;
                            _query = city.name;
                            _filteredCities = [];
                            _isCitySelected = true;
                            _dismissKeyboard();
                          });
                        },
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: keyboardVisible ? 160 : 160,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Add Description',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _onDescriptionChanged,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: (_isCitySelected && _isDescriptionFilled)
                            ? () async {
                                final selectedCity = _controller.text;
                                final description = _descriptionController.text;
                                if (selectedCity.isNotEmpty &&
                                    description.isNotEmpty) {
                                  await _preferencesService.saveLocation(
                                      selectedCity, description);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('City saved successfully!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please fill in all fields.'),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Text('Save City'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<City>> loadCities() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final data = await json.decode(response) as List;
    return data.map((city) => City.fromJson(city)).toList();
  }
}
