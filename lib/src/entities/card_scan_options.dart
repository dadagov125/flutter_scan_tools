import 'package:flutter/material.dart';

import 'scan_options.dart';

class CardScanOptions extends ScanOptions {
  const CardScanOptions(
      {this.requireHolder = false, this.requireExpiry = false, Widget? overlay})
      : super(overlay: overlay);

  final bool requireHolder;
  final bool requireExpiry;
}
