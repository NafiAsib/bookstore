import 'package:bookstore/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final user = FirebaseAuth.instance.currentUser;

  Future<String> addFavorite(Book book) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('favorites').doc(user?.uid);

      final books = await getFavorites();
      books.add(book);

      final bookJson = books.map((book) => book.toJson()).toList();

      final favBooks = <String, dynamic>{
        "books": bookJson,
      };

      await docRef
          .set(favBooks)
          .then((value) {})
          .catchError((error) => print(error));
      return 'Added book to favorites!';
    } on Exception catch (e) {
      print(e);
      return 'Error occured!';
    }
  }

  Future<List<Book>> getFavorites() async {
    try {
      final docFavorites =
          FirebaseFirestore.instance.collection('favorites').doc(user?.uid);
      final snapshot = await docFavorites.get();

      if (snapshot.exists) {
        final booksResponse = snapshot.data()!['books'];

        final List<Book> books = [];
        booksResponse.forEach(
            (book) => books.add(Book.fromJson(book as Map<String, dynamic>)));
        return books;
      } else {
        return [];
      }
    } on Exception catch (e) {
      print(e);
      return [];
      // return 'Error occured!';
    }
  }
  // Future<string> removeFavorite() {}
}
