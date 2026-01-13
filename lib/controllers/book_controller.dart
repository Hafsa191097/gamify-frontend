import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class BookController extends GetxController {
  var topBooks = <Book>[].obs;
  var popularBooks = <Book>[].obs;
  var allBooks = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
  var favoriteBooks = <Book>[].obs;
  var selectedIndex = 0.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var selectedStatus = 'All'.obs;

  final String base_url = 'https://annett-stereoscopic-xavi.ngrok-free.dev';

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Fetch books from API
  Future<void> fetchBooks() async {
    final token = await _secureStorage.read(key: 'auth_token');
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('$base_url/books'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List<dynamic> bookList = [];
        if (data is List) {
          bookList = data;
        } else if (data['items'] != null) {
          bookList = data['items'] as List<dynamic>;
        } else if (data['data'] != null) {
          bookList = data['data'] as List<dynamic>;
        } else if (data['books'] != null) {
          bookList = data['books'] as List<dynamic>;
        }

        // Convert to Book objects
        final List<Book> fetchedBooks = bookList
            .map((book) => Book.fromJson(book as Map<String, dynamic>))
            .toList();

        allBooks.value = fetchedBooks;

        // Separate into top and popular books
        topBooks.value = fetchedBooks.take(2).toList();
        popularBooks.value = fetchedBooks
            .where((book) => book.isPopular)
            .toList();

        // If no popular books, use remaining books
        if (popularBooks.isEmpty && fetchedBooks.length > 2) {
          popularBooks.value = fetchedBooks.skip(2).take(2).toList();
        }

        filteredBooks.value = fetchedBooks;
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized. Please login again.';
      } else if (response.statusCode == 404) {
        errorMessage.value = 'No books found';
        allBooks.value = [];
        topBooks.value = [];
        popularBooks.value = [];
      } else {
        errorMessage.value =
            'Failed to load books. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      allBooks.value = [];
      topBooks.value = [];
      popularBooks.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Search books by title or description
  void searchBooks(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredBooks.value = allBooks;
    } else {
      filteredBooks.value = allBooks
          .where(
            (book) =>
                book.title.toLowerCase().contains(query.toLowerCase()) ||
                (book.description?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }
  }

  /// Filter books by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    if (status == 'All') {
      filteredBooks.value = allBooks;
    } else {
      filteredBooks.value = allBooks
          .where((book) => book.status?.toLowerCase() == status.toLowerCase())
          .toList();
    }
  }

  /// Get unique statuses from books
  List<String> getStatuses() {
    Set<String> statuses = {'All'};
    for (var book in allBooks) {
      if (book.status != null && book.status!.isNotEmpty) {
        statuses.add(book.status!);
      }
    }
    return statuses.toList();
  }

  /// Toggle favorite
  void toggleFavorite(Book book) {
    if (favoriteBooks.any((b) => b.id == book.id)) {
      favoriteBooks.removeWhere((b) => b.id == book.id);
    } else {
      favoriteBooks.add(book);
    }
  }

  /// Check if book is favorite
  bool isFavorite(Book book) {
    return favoriteBooks.any((b) => b.id == book.id);
  }

  /// Get book details
  Book? getBookById(int id) {
    try {
      return allBooks.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh books list
  Future<void> refreshBooks() async {
    await fetchBooks();
  }

  /// Change tab
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void clearMessages() {
    errorMessage.value = '';
  }
}
