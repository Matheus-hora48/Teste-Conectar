import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      log('Erro não tratado capturado', error: error, stackTrace: stackTrace);
    },
  );
}