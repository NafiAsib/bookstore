part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class LoadBooks extends BooksEvent {
  final List<Book> books;

  const LoadBooks({this.books = const <Book>[]});

  @override
  List<Object> get props => [books];
}

class SearchBooks extends BooksEvent {
  final String searchQuery;

  const SearchBooks({required this.searchQuery});
}
