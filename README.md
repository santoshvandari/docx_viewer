# Docx_Viewer

A Flutter package for displaying DOCX files as text in your app across all platforms including Web, Android, iOS, Windows, macOS, and Linux.

## Features

- **Multi-platform Support**: Works on Web, Android, iOS, Windows, macOS, and Linux
- **Read and Display DOCX Files**: Extract and display content from `.docx` files
- **Network File Support**: Load DOCX files from URLs (works on all platforms)
- **Bytes Support**: Process DOCX from bytes (recommended for web with file pickers)
- **File Validation**: Automatic checking of file existence and supported file types
- **Error Handling**: Customizable error handling callback via the `onError` parameter
- **Customizable Display**: Adjust font size for displaying the text

## Installation

- To use this package, add `docx_viewer` to your `pubspec.yaml` file:
```yaml
dependencies:
  docx_viewer: ^latest_version
```
- Then run:
```bash
flutter pub get
```

## Usage

### Basic Usage

#### 1. Network URL (All Platforms)
Load DOCX files from the internet - works on all platforms including web:

```dart
import 'package:docx_viewer/docx_viewer.dart';

DocxView(
  filePath: 'https://example.com/document.docx',
  fontSize: 18, // Optional: Adjust the font size
  onError: (error) {
    print('Error: $error');
  },
)
```

#### 2. Local File Path (Mobile/Desktop Only)
Load DOCX files from local storage on mobile and desktop platforms:

```dart
import 'package:docx_viewer/docx_viewer.dart';

DocxView(
  filePath: '/path/to/your/document.docx',
  fontSize: 18,
  onError: (error) {
    print('Error: $error');
  },
)
```

#### 3. Bytes with File Picker (All Platforms - Recommended for Web)
For web compatibility, use a file picker package and pass the bytes:

```dart
import 'package:docx_viewer/docx_viewer.dart';
import 'package:file_picker/file_picker.dart';

// Pick a file
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['docx'],
  withData: true, // Important for web!
);

if (result != null && result.files.first.bytes != null) {
  // Display the DOCX file
  DocxView(
    bytes: result.files.first.bytes!,
    fontSize: 18,
    onError: (error) {
      print('Error: $error');
    },
  )
}
```

### Complete Example

```dart
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DocxViewerPage(),
    );
  }
}

class DocxViewerPage extends StatefulWidget {
  const DocxViewerPage({super.key});

  @override
  State<DocxViewerPage> createState() => _DocxViewerPageState();
}

class _DocxViewerPageState extends State<DocxViewerPage> {
  Uint8List? docxBytes;
  
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
      withData: true,
    );
    
    if (result != null && result.files.first.bytes != null) {
      setState(() {
        docxBytes = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOCX Viewer')),
      body: docxBytes != null
          ? DocxView(
              bytes: docxBytes!,
              fontSize: 16,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $error')),
                );
              },
            )
          : Center(
              child: ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick DOCX File'),
              ),
            ),
    );
  }
}
```

### Parameters
**You must provide either `filePath` or `bytes`**

- `filePath`: The path or network URL of the DOCX file to display.
  - On **mobile/desktop**: Supports both local file paths and network URLs
  - On **web**: Only network URLs are supported (use `bytes` for local files)
- `bytes`: DOCX file bytes (Uint8List). **Recommended for web** when using file pickers.
- `fontSize`: The font size for displaying the text (optional, default is 16).
- `onError`: A callback to handle errors if the file can't be loaded (optional).

### Platform-Specific Notes

#### Web Platform
On web, direct file path access is not supported due to browser security restrictions. You have two options:
1. **Use network URLs**: `DocxView(filePath: 'https://example.com/doc.docx')`
2. **Use file picker with bytes**: Recommended for local files on web

```dart
// Add file_picker to your pubspec.yaml
dependencies:
  file_picker: ^6.0.0

// Use it with DocxView
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['docx'],
  withData: true, // Essential for web!
);

if (result != null) {
  DocxView(bytes: result.files.first.bytes!)
}
```

#### Mobile & Desktop Platforms
All three methods work:
- Local file paths: `DocxView(filePath: '/path/to/file.docx')`
- Network URLs: `DocxView(filePath: 'https://example.com/doc.docx')`
- Bytes: `DocxView(bytes: fileBytes)`

## Error Handling

If the DOCX file path is empty, the file type is unsupported, or the file doesn't exist, an error message will be displayed. If you provide an `onError` callback, it will be invoked with the error.

## Contributing
We welcome contributions! If you'd like to contribute to this Flutter Package Project, please check out our [Contribution Guidelines](Contribution.md).

## Code of Conduct
Please review our [Code of Conduct](CodeOfConduct.md) before participating in this app.

## License
This project is licensed under the MIT [License](LICENSE).


## Author

[Santosh Bhandari](mailto:info@bhandari-santosh.com.np)

## Support Development

If you find this package helpful and would like to support its development, consider contributing through one of these platforms:

### These are supported funding model platforms:

- **GitHub Sponsors**: [santoshvandari](https://github.com/sponsors/santoshvandari)
- **Ko-fi**: [santoshvandari](https://ko-fi.com/santoshvandari)
- **Buy Me a Coffee**: [santoshvandari](https://www.buymeacoffee.com/santoshvandari)


### Thank you for your support!
