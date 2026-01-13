import 'package:gamify/models/chapter.dart';
import 'package:gamify/services/headers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChaptersController extends GetxController {
  final String base_url = 'https://annett-stereoscopic-xavi.ngrok-free.dev';

  var isLoading = false.obs;
  var bookDetail = Rxn<BookDetail>();
  var errorMessage = ''.obs;

  Future<void> getBookWithChapters({required int bookId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = ApiHeaders.getHeaders();

      final response = await http.get(
        Uri.parse('$base_url/books/$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bookDetail.value = BookDetail.fromJson(data);
        print('✅ Loaded ${bookDetail.value!.chapters.length} chapters');
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized. Please login again.';
      } else if (response.statusCode == 404) {
        errorMessage.value = 'Book not found';
      } else {
        errorMessage.value =
            'Failed to load book. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String getSummarySummary(String summary) {
    if (summary.length <= 100) {
      return summary;
    }
    return '${summary.substring(0, 100)}...';
  }
}
