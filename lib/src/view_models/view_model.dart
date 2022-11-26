import 'package:flutter/material.dart';

abstract class ViewModel {
  ViewModel(this.context);

  final BuildContext context;

  void init() {}

  void dispose() {}
}
