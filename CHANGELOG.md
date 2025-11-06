## Changelog

## 1.0.0
- **Web Support Added**: The package now supports all Flutter platforms including Web!
- **Platform-Specific Implementations**: Added conditional imports for seamless cross-platform compatibility
- **Enhanced API**: 
  - Network URLs now work on all platforms including web
  - Bytes parameter recommended for web with file pickers
  - Local file paths work on mobile/desktop platforms
- **Improved Error Handling**: Clear error messages for platform-specific limitations
- **Deprecated `file` parameter**: Use `filePath` or `bytes` instead for better cross-platform support
- **Updated Documentation**: Comprehensive examples for web, mobile, and desktop usage
- **New Features**:
  - Web platform support with file picker integration
  - Direct bytes processing without temp files (web-compatible)
  - Platform detection with helpful error messages
- **ISSUE**: May be introduction of new issues; please report any problems on GitHub.

## 0.2.2
- Updated the README.md
- Expanded DOCX viewer widget to support loading documents from a file path, a file object, or raw bytes, providing greater flexibility for users.
- Updated to read only docx files.

## 0.2.1
- Updated the README.md
- Added the Handeling of the File From the Internet or Network too.

## 0.2.0
- Added the `extractTextFromDocx` method to extract text from the DOCX file.

## 0.1.1
- Added Example Code 
- Updated the README.md
- Handles file validation (file path check, file type check, file existence check). 
- Added error handling with an optional callback function (`onError`). 
- Customizable font size for text display.

## 0.1.0
- Initial release of the `docx_viewer` package. 
- Added support for displaying DOCX files as text. 

