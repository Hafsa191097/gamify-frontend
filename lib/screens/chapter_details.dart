import 'package:flutter/material.dart';
import 'package:gamify/controllers/chapter_details.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChapterDetailScreen extends StatefulWidget {
  final int chapterId;
  final String chapterTitle;

  const ChapterDetailScreen({
    Key? key,
    required this.chapterId,
    required this.chapterTitle,
  }) : super(key: key);

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('WebView: Page started loading');
          },
          onPageFinished: (String url) {
            print('WebView: Page finished loading');
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final ChapterDetailController controller = Get.put(
      ChapterDetailController(),
    );

    // Load chapter details on screen open
    Future.microtask(() {
      controller.getChapterDetail(chapterId: widget.chapterId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
        ),
        title: Text(
          widget.chapterTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3142),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // Show loading spinner while fetching chapter
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6659AA)),
          );
        }

        // Show error message
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color(0xFFEA4335),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.getChapterDetail(chapterId: widget.chapterId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6659AA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        // Chapter loaded successfully
        final chapter = controller.chapterDetail.value;
        if (chapter == null) {
          return const SizedBox();
        }

        // If game HTML is loaded, show game
        if (controller.gameHtml.value.isNotEmpty) {
          return Stack(
            children: [
              // WebView with HTML game
              WebViewWidget(
                controller: _webViewController
                  ..loadHtmlString(
                    controller.gameHtml.value,
                    baseUrl: 'https://annett-stereoscopic-xavi.ngrok-free.dev',
                  ),
              ),
              // Loading indicator while game is loading
              if (controller.isLoadingGame.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6659AA)),
                  ),
                ),
            ],
          );
        }

        // If chapter has no game, show chapter summary
        if (chapter.game == null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chapter number and title
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6659AA),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${chapter.chapterNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Status: ${chapter.status}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Chapter summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        chapter.summaryText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // No game message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFCD34D),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFFD97706)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No game available for this chapter yet.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Loading game
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF6659AA)),
              SizedBox(height: 16),
              Text(
                'Loading game...',
                style: TextStyle(fontSize: 16, color: Color(0xFF2D3142)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
