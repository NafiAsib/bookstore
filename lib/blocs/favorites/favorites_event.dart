part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  final List<Book> books;

  const LoadFavorites({this.books = const <Book>[]});

  @override
  List<Object> get props => [books];
}

class AddFavorite extends FavoritesEvent {
  final Book book;

  const AddFavorite({required this.book});
}
