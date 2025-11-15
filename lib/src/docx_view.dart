import 'dart:typed_data';

import 'package:docx_viewer/src/extract_text_from_docx.dart';
import 'package:docx_viewer/utils/support_type.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Conditional imports for platform-specific file operations
import 'file_io_stub.dart'
    if (dart.library.io) 'file_io_mobile.dart'
    if (dart.library.html) 'file_io_web.dart';

/// A widget for displaying Word documents, including .docx file types.
///
/// The [DocxView] widget takes a [filePath], an optional [fontSize], and an optional [onError] callback function.
/// It reads the content of the DOCX file and displays it as text within a Flutter application.
///
/// Supported document types:
/// - DOCX: Displayed as text after converting from DOCX binary format.
///
/// Platform Support:
/// - **Mobile/Desktop**: Supports [filePath] (local paths and network URLs) and [bytes]
/// - **Web**: Supports [bytes] (use with file picker) and [filePath] (network URLs only)
///
/// Example usages:
/// ```dart
/// // Local file (mobile/desktop only)
/// DocxView(filePath: '/path/to/your/document.docx')
///
/// // Network URL (all platforms)
/// DocxView(filePath: 'https://example.com/document.docx')
///
/// // Bytes from file picker (all platforms, recommended for web)
/// DocxView(bytes: docxBytes)
/// ```
class DocxView extends StatefulWidget {
  final String?
      filePath; // The path to the DOCX file or URL (local paths not supported on web)
  @Deprecated(
    'Use filePath or bytes instead. This parameter will be removed in a future version.',
  )
  final dynamic file; // Deprecated: The DOCX file (not supported on web)
  final Uint8List? bytes; // The bytes of a DOCX file (recommended for web)
  final int fontSize; // Optional font size for displaying the text
  final Function(Exception)? onError; // Optional callback for handling errors

  /// Creates a [DocxView] widget.
  ///
  /// Required to define [filePath] or [bytes].
  /// - [filePath]: Path or network URL of the DOCX file to display.
  ///   On web, only network URLs are supported. Use [bytes] for local files on web.
  /// - [bytes]: DOCX bytes to display. Recommended for web with a file picker.
  /// - [fontSize]: Optional font size for displaying the text (defaults to 16).
  /// - [onError]: Optional callback for handling errors.
  const DocxView({
    super.key,
    this.filePath,
    @Deprecated('Use filePath or bytes instead') this.file,
    this.bytes,
    this.fontSize = 16,
    this.onError,
  });

  @override
  State<DocxView> createState() => _DocxViewState();
}

class _DocxViewState extends State<DocxView> {
  String? fileContent;
  bool isLoading = true;
  static const double _padding = 10.0;

  @override
  void initState() {
    _validateAndLoadDocxContent();
    super.initState();
  }

  /// Validates the file path, determines if it's a network or local file, and loads the DOCX content.
  Future<void> _validateAndLoadDocxContent() async {
    // Check if any input is provided
    if ((widget.filePath == null || widget.filePath!.isEmpty) &&
        widget.bytes == null) {
      _handleError(
        Exception(
          "No input provided. You must specify either filePath or bytes.",
        ),
      );
      return;
    }

    // Ensure that only one of the parameters is provided
    if ((widget.bytes != null) && (widget.filePath != null)) {
      _handleError(Exception("Define only one of: filePath or bytes"));
      return;
    }

    // Handle bytes parameter (works on all platforms)
    if (widget.bytes != null) {
      await _loadDocxBytesContent(widget.bytes!);
      return;
    }

    // Handle network URLs (works on all platforms)
    if (widget.filePath != null && widget.filePath!.startsWith('http')) {
      await _loadDocxContentFromNetwork(widget.filePath!);
      return;
    }

    // Handle local file paths
    if (kIsWeb) {
      // On web, local file paths are not supported
      _handleError(
        Exception(
          "Direct file path access is not supported on web. "
          "Please use 'bytes' parameter with a file picker package "
          "(e.g., file_picker) or provide a network URL.",
        ),
      );
      return;
    }

    // Load from local file path (mobile/desktop only)
    if (widget.filePath != null) {
      await _loadDocxContentFromPath(widget.filePath!);
    }
  }

  /// Loads the content from bytes of a DOCX file.
  /// This method works on all platforms.
  Future<void> _loadDocxBytesContent(Uint8List bytes) async {
    try {
      final content = extractTextFromDocxBytes(bytes);
      setState(() {
        fileContent = content;
        isLoading = false;
      });
    } catch (e) {
      _handleError(Exception("Error reading file: ${e.toString()}"));
    }
  }

  /// Loads the content from a DOCX file path stored locally.
  /// This method only works on mobile and desktop platforms.
  Future<void> _loadDocxContentFromPath(String path) async {
    try {
      // Check the file extension to determine the file type
      final fileExtension = path.split('.').last.toLowerCase();

      // Check if the file extension is supported (DOCX)
      if (fileExtension != Supporttype.docx) {
        _handleError(Exception("Unsupported file type: .$fileExtension"));
        return;
      }

      // Check if file exists
      final exists = await FileIO.fileExists(path);
      if (!exists) {
        _handleError(Exception("File not found: $path"));
        return;
      }

      // Extract text from the file
      final content = await extractTextFromDocx(path);
      setState(() {
        fileContent = content;
        isLoading = false;
      });
    } catch (e) {
      _handleError(Exception("Error reading file: ${e.toString()}"));
    }
  }

  /// Loads the content from a DOCX file available over the network.
  /// This method works on all platforms including web.
  Future<void> _loadDocxContentFromNetwork(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Process bytes directly without writing to temp file (web-compatible)
        await _loadDocxBytesContent(response.bodyBytes);
      } else {
        _handleError(
          Exception(
            "Failed to load file from network. Status code: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      _handleError(Exception("Error downloading file: ${e.toString()}"));
    }
  }

  /// Handles errors by calling the [onError] callback if provided, or displaying the error message.
  void _handleError(Exception error) {
    if (widget.onError != null) {
      widget.onError!(error);
    } else {
      setState(() {
        fileContent = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Text(
                fileContent ?? 'No content to display.',
                style: TextStyle(fontSize: widget.fontSize.toDouble()),
              ),
            ),
    );
  }
}
