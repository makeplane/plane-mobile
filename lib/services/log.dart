import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  Log() {
    _logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2, // number of method calls to be displayed
          errorMethodCount:
              8, // number of method calls if stacktrace is provided
          lineLength: 120, // width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
      level: kDebugMode ? Level.debug : Level.info,
    );
  }
  static final shared = Log();
  late Logger _logger;

  static void info(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Log.shared._logger.i(msg, error: error, stackTrace: stackTrace);
    }
  }

  static void debug(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Log.shared._logger.d(msg, error: error, stackTrace: stackTrace);
    }
  }

  static void warn(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Log.shared._logger.w(msg, error: error, stackTrace: stackTrace);
    }
  }

  static void trace(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Log.shared._logger.t(msg, error: error, stackTrace: stackTrace);
    }
  }

  static void error(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Log.shared._logger.e(msg, error: error, stackTrace: stackTrace);
    }
  }
}
