library digicarepor.globals;

import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

// EventBus eventBus = EventBus();