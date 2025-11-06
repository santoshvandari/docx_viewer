import 'dart:io';
import 'dart:typed_data';

/// Mobile and Desktop implementation for file IO operations.
/// Uses dart:io for file system access.
class FileIO {
  /// Reads file bytes from the given path using dart:io.
  static Future<Uint8List> readFileBytes(String path) async {
    final file = File(path);
    return await file.readAsBytes();
  }

  /// Checks if a file exists at the given path using dart:io.
  static Future<bool> fileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }
}
