part of 'books_bloc.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

// class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<Book> books;

  const BooksLoaded({this.books = const <Book>[]});

  @override
  List<Object> get props => [books];
}

class BooksError extends BooksState {
  final String errorMsg;

  const BooksError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
