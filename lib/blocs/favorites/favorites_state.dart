part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Book> books;

  const FavoritesLoaded({this.books = const <Book>[]});

  @override
  List<Object> get props => [books];
}

class FavoritesAdded extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesError extends FavoritesState {
  final String error;

  const FavoritesError({required this.error});

  @override
  List<Object> get props => [error];
}
