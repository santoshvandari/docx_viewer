# Docx_Viewer

A Flutter package for displaying DOCX files as text in your app. This package uses the `docx_to_text` package to read DOCX files and display their content as text.

## Features

- Read and display the content of DOCX files.
- Supports `.docx` and `.doc` file formats.
- Can handle files from the internet or network.
- Handles file validation, such as checking if the file exists and if the file type is supported.
- Provides a customizable error handling callback via the `onError` parameter.
- Optionally customize the font size for displaying the text.

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

Here's an example of how to use the `DocxView` widget:

```dart
import 'package:docx_viewer/docx_viewer.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('DOCX Viewer')),
      body: DocxView(
        filePath: '/path/to/your/document.docx',
        fontSize: 18, // Optional: Adjust the font size
        onError: (error) {
          // Handle error if provided
          print(error);
        },
      ),
    ),
  ));
}
```

### Parameters
##### You must provide either `filePath`, `file`, or `bytes`
- `filePath`: The path to the DOCX file to display.
- `file`: The DOCX file to display.
- `bytes`: DOCX bytes to display.
- `fontSize`: The font size for displaying the text (optional, default is 16).
- `onError`: A callback to handle errors if the file can't be loaded (optional).

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
<!-- - **Open Collective**: [santoshvandari](https://opencollective.com/santoshvandari) -->
- **Ko-fi**: [santoshvandari](https://ko-fi.com/santoshvandari)
- **Buy Me a Coffee**: [santoshvandari](https://www.buymeacoffee.com/santoshvandari)


### Thank you for your support!
