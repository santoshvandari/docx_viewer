import 'dart:typed_data';

/// Web implementation for file IO operations.
/// File system access is not supported on web platform.
class FileIO {
  /// On web, direct file path access is not supported.
  /// Users should use the bytes parameter or network URLs instead.
  static Future<Uint8List> readFileBytes(String path) async {
    throw UnsupportedError(
        'Direct file path access is not supported on web. '
        'Please use the "bytes" parameter with a file picker, '
        'or provide a network URL.');
  }

  /// On web, direct file system access is not supported.
  static Future<bool> fileExists(String path) async {
    throw UnsupportedError(
        'File system access is not supported on web. '
        'Please use the "bytes" parameter or network URLs.');
  }
}
