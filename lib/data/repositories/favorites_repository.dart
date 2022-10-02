import 'package:bookstore/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final user = FirebaseAuth.instance.currentUser;

  Future<String> addFavorite(Book book) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('favorites').doc(user?.uid);

      final bookJson = book.toJson();

      await docRef
          .set(bookJson)
          .then((value) {})
          .catchError((error) => print(error));
      return 'Added book to favorites!';
    } on Exception catch (e) {
      print(e);
      return 'Error occured!';
    }
  }

  Future<List<Book>?> getFavorites() async {
    try {
      final docFavorites =
          FirebaseFirestore.instance.collection('lesson').doc(user?.uid);
      final snapshot = await docFavorites.get();
      List<Book> books;

      if (snapshot.exists) {
        print(snapshot.data());
        //  books = snapshot.data()!.map((i) => Book.fromJson(i))
        //     .toList();
        // return Book.fromJson(snapshot.data()!);
      } else {
        return [];
      }
    } on Exception catch (e) {
      print(e);
      // return 'Error occured!';
    }
  }
  // Future<string> removeFavorite() {}
}
