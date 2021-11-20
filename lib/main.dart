import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:try_ddd/presentation/core/app_widget.dart';

import 'injection.dart';

void main() {
  configureInjection(Environment.prod); //注入
  runApp(const AppWidget());
}
