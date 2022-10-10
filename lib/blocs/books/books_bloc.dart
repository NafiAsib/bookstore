import 'package:bloc/bloc.dart';
import 'package:bookstore/data/repositories/books_repository.dart';
import 'package:bookstore/models/book.dart';
import 'package:equatable/equatable.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository bookRepository;
  BooksBloc({required this.bookRepository}) : super(BooksLoading()) {
    on<LoadBooks>((event, emit) async {
      emit(BooksLoading());
      try {
        final books = await bookRepository.getBooks();
        emit(BooksLoaded(books: books!));
      } catch (e) {
        emit(BooksError(errorMsg: e.toString()));
      }
    });
    on<SearchBooks>((event, emit) async {
      emit(BooksLoading());
      try {
        final books = await bookRepository.searchBooks(event.searchQuery);
        emit(BooksLoaded(books: books!));
      } catch (e) {
        emit(BooksError(errorMsg: e.toString()));
      }
    });
  }
}
