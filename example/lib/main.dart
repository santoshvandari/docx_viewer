import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:docx_viewer/docx_viewer.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOCX Viewer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DocumentViewerPage(),
    );
  }
}

class DocumentViewerPage extends StatefulWidget {
  const DocumentViewerPage({super.key});

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  String? filePath;
  Uint8List? fileBytes;
  String? errorMessage;
  bool showNetworkExample = false;

  // Example network URL for testing
  final String networkUrl =
      'https://documents1.worldbank.org/curated/en/611681600840497459/A-Proposed-Methodology-for-Data-Collection-and-Use-to-Support-the-Early-Warning-Mechanism-Implementation.docx';

  // Function to pick a DOCX file from local storage
  Future<void> pickFile() async {
    setState(() {
      errorMessage = null;
    });

    try {
      // Use file_picker to select a DOCX file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
        withData: kIsWeb, // Important: get bytes on web platform
      );

      if (result != null) {
        if (kIsWeb) {
          // On web, use bytes
          setState(() {
            fileBytes = result.files.single.bytes;
            filePath = null;
            showNetworkExample = false;
          });
        } else {
          // On mobile/desktop, use file path
          setState(() {
            filePath = result.files.single.path;
            fileBytes = null;
            showNetworkExample = false;
          });
        }
      } else {
        // Handle when no file is selected
        debugPrint("No file selected");
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error picking file: $e";
      });
    }
  }

  // Function to load network URL example
  void loadNetworkExample() {
    setState(() {
      filePath = networkUrl;
      fileBytes = null;
      showNetworkExample = true;
      errorMessage = null;
    });
  }

  // Function to clear the current document
  void clearDocument() {
    setState(() {
      filePath = null;
      fileBytes = null;
      showNetworkExample = false;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasDocument = filePath != null || fileBytes != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DOCX Viewer Demo'),
        elevation: 2,
        actions: hasDocument
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear document',
                  onPressed: clearDocument,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Platform indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: kIsWeb ? Colors.blue.shade50 : Colors.green.shade50,
            child: Row(
              children: [
                Icon(
                  kIsWeb ? Icons.web : Icons.phone_android,
                  size: 20,
                  color: kIsWeb ? Colors.blue : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Running on: ${kIsWeb ? "Web Platform" : "Mobile/Desktop Platform"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kIsWeb ? Colors.blue.shade900 : Colors.green.shade900,
                  ),
                ),
              ],
            ),
          ),
          
          // Error message
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          // Document viewer or placeholder
          Expanded(
            child: hasDocument
                ? DocxView(
                    filePath: filePath,
                    bytes: fileBytes,
                    fontSize: 16,
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "No document selected",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            kIsWeb
                                ? "On web, you can load documents from file picker or network URLs"
                                : "Pick a local file or load from a network URL",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          // Pick file button
                          ElevatedButton.icon(
                            onPressed: pickFile,
                            icon: const Icon(Icons.file_upload),
                            label: const Text("Pick a DOCX file"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          const Text("— OR —"),
                          const SizedBox(height: 16),
                          
                          // Load network example button
                          OutlinedButton.icon(
                            onPressed: loadNetworkExample,
                            icon: const Icon(Icons.cloud_download),
                            label: const Text("Load Network Example"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Platform-specific info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: Colors.blue.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      kIsWeb
                                          ? "Web Platform Features"
                                          : "Mobile/Desktop Features",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (kIsWeb) ...[
                                  const Text("✓ File picker with bytes"),
                                  const Text("✓ Network URLs"),
                                  const Text("✗ Direct file paths (not supported)"),
                                ] else ...[
                                  const Text("✓ File picker with paths"),
                                  const Text("✓ Network URLs"),
                                  const Text("✓ Direct file paths"),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
