import 'package:bookstore/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final user = FirebaseAuth.instance.currentUser;

  Future<String> addFavorite(Book book) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('favorites').doc(user?.uid);

      final List<Book> books = [];
      final favorites = await getFavorites();

      if (favorites != null && favorites.isNotEmpty) {
        books.addAll(favorites);
        try {
          favorites.firstWhere((e) => e.id == book.id);
          throw Exception('Already added to favorites');
        } catch (e) {
          if (e.toString() == 'Exception: Already added to favorites') {
            final filteredBooks =
                favorites.where((element) => element.id != book.id).toList();

            removeFavorite(filteredBooks);
            return 'Removed from favorites';
          } else {
            books.add(book);
          }
        }
      } else {
        books.add(book);
      }

      // books.add(book);
      // print('Attemting to add');
      final bookJson = books.map((book) => book.toJson()).toList();

      final favBooks = <String, dynamic>{
        "books": bookJson,
      };

      await docRef
          .set(favBooks)
          .then((value) {})
          .catchError((error) => throw Exception(error.toString()));
      return 'Added book to favorites';
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Book>?> getFavorites() async {
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
      throw Exception(e.toString());
    }
  }

  Future<String> removeFavorite(List<Book> books) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('favorites').doc(user?.uid);

      final bookJson = books.map((book) => book.toJson()).toList();

      final favBooks = <String, dynamic>{
        "books": bookJson,
      };

      await docRef
          .update(favBooks)
          .then((value) {})
          .catchError((error) => throw Exception(error.toString()));
      return 'Updated favorites';
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
