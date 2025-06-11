import 'dart:async';
import 'package:flutter/material.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;

  final _temperatureController = StreamController<double>.broadcast();
  final _humidityController = StreamController<double>.broadcast();
  final _soundController = StreamController<double>.broadcast();

  Stream<double> get temperatureStream => _temperatureController.stream;
  Stream<double> get humidityStream => _humidityController.stream;
  Stream<double> get soundStream => _soundController.stream;

  SensorService._internal();

  void updateTemperature(double temperature) {
    _temperatureController.add(temperature);
  }

  void updateHumidity(double humidity) {
    _humidityController.add(humidity);
  }

  void updateSound(double sound) {
    _soundController.add(sound);
  }

  void dispose() {
    _temperatureController.close();
    _humidityController.close();
    _soundController.close();
  }
} 