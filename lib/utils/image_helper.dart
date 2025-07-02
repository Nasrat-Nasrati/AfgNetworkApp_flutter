import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImageHelper {
  static Future<String> downloadAndSaveImage(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(url); // نام فایل از URL استخراج می‌شود
    final filePath = path.join(directory.path, fileName);
    final file = File(filePath);

    if (!await file.exists()) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error downloading image: $e');
        return '';
      }
    }

    return file.path;
  }
}
