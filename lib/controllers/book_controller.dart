import 'package:get/get.dart';
import '../models/book.dart';

class BookController extends GetxController {
  var topBooks = <Book>[].obs;
  var popularBooks = <Book>[].obs;
  var favoriteBooks = <Book>[].obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void fetchBooks() {
    // Sample data - in real app, fetch from API
    topBooks.value = [
      Book(
        id: '1',
        title: 'Jungle Book',
        author: 'Novel',
        category: 'Novel',
        rating: 3.0,
        coverColor:
            'https://images.squarespace-cdn.com/content/v1/5fc7868e04dc9f2855c99940/d13d2ad3-bca7-4544-b7bf-71bf7af7b283/laura-barrett-illustration-moon-stars-book-cover-design.jpg',
        imageUrl: 'assets/jungle_book.png',
      ),
      Book(
        id: '2',
        title: 'The Wee Free Men',
        author: 'Manav Kaul',
        category: 'Fantasy',
        rating: 4.0,
        coverColor:
            'https://blog-cdn.reedsy.com/directories/gallery/287/large_144c0ab0a2cdfbec693393cc62432b54.jpg',
        imageUrl: 'assets/wee_free_men.png',
      ),
    ];

    popularBooks.value = [
      Book(
        id: '3',
        title: 'Alice in Wonderland',
        author: 'Suzie Nami',
        category: 'Fiction',
        rating: 4.5,
        coverColor:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2KuFBHfsxQZK3XSsXtiRqaXOWcRn2MId1Tw&s',
        imageUrl: 'assets/alice.png',
        isPopular: true,
      ),
      Book(
        id: '4',
        title: 'Salvajito',
        author: 'Narto halip',
        category: 'Adventure',
        rating: 4.2,
        coverColor:
            'https://ichef.bbci.co.uk/images/ic/480xn/p08g1mbd.jpg.webp',
        imageUrl: 'assets/salvajito.png',
        isPopular: true,
      ),
    ];
  }

  void toggleFavorite(Book book) {
    if (favoriteBooks.any((b) => b.id == book.id)) {
      favoriteBooks.removeWhere((b) => b.id == book.id);
    } else {
      favoriteBooks.add(book);
    }
  }

  bool isFavorite(Book book) {
    return favoriteBooks.any((b) => b.id == book.id);
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
