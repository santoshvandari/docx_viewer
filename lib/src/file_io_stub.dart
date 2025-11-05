import 'dart:typed_data';

/// Stub implementation for file IO operations.
/// This will be replaced by platform-specific implementations at compile time.
class FileIO {
  /// Reads file bytes from the given path.
  /// This method will use platform-specific implementation.
  static Future<Uint8List> readFileBytes(String path) {
    throw UnsupportedError(
      'Cannot read files without platform-specific implementation',
    );
  }

  /// Checks if a file exists at the given path.
  /// This method will use platform-specific implementation.
  static Future<bool> fileExists(String path) {
    throw UnsupportedError(
      'Cannot check file existence without platform-specific implementation',
    );
  }
}
