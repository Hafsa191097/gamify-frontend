import 'package:gamify/config.dart';
import 'package:gamify/models/chapter_details.dart';
import 'package:gamify/services/headers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChapterDetailController extends GetxController {
  var isLoading = false.obs;
  var chapterDetail = Rxn<ChapterDetail>();
  var gameHtml = ''.obs;
  var errorMessage = ''.obs;
  var isLoadingGame = false.obs;

  // Fetch chapter detail with game
  Future<void> getChapterDetail({required int chapterId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      late String base_url = EnvironmentConfig.baseUrl;
      final headers = ApiHeaders.getHeaders();

      final response = await http.get(
        Uri.parse('$base_url/chapters/$chapterId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        chapterDetail.value = ChapterDetail.fromJson(data);
        print(
          '✅ Chapter loaded with game ID: ${chapterDetail.value?.game?.id}',
        );

        // If game exists, fetch HTML
        if (chapterDetail.value?.game != null) {
          await getGameHtml(gameId: chapterDetail.value!.game!.id);
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized. Please login again.';
      } else if (response.statusCode == 404) {
        errorMessage.value = 'Chapter not found';
      } else {
        errorMessage.value =
            'Failed to load chapter. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch game HTML content
  Future<void> getGameHtml({required int gameId}) async {
    try {
      late String base_url = EnvironmentConfig.baseUrl;
      isLoadingGame.value = true;

      final headers = ApiHeaders.getHeaders();

      final response = await http.get(
        Uri.parse('$base_url/game-render/$gameId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Response body is the HTML content as string
        gameHtml.value = response.body;
        print('✅ Game HTML loaded (${response.body.length} bytes)');
      } else if (response.statusCode == 404) {
        errorMessage.value = 'Game not found';
      } else {
        errorMessage.value =
            'Failed to load game. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error loading game: ${e.toString()}';
    } finally {
      isLoadingGame.value = false;
    }
  }
}
