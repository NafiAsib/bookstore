import 'package:bookstore/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BooksRepository {
  Future<List<Book>?> getBooks() async {
    final queryParams = {
      'q': 'flutter',
    };
    var url =
        Uri.https('www.googleapis.com', '/books/v1/volumes/', queryParams);
    List<Book> books;
    try {
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);

      books = (decodedResponse['items'] as List)
          .map((i) => Book.fromJson(i))
          .toList();

      for (var book in books) {
        print(book.volumeInfo!.title);
      }
      return books;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
