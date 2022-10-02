// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bookstore/models/book.dart';

import 'package:bookstore/data/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;
  FavoritesBloc({
    required this.favoritesRepository,
  }) : super(FavoritesLoading()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final books = await favoritesRepository.getFavorites();
        emit(FavoritesLoaded(books: books!));
      } catch (e) {
        emit(FavoritesError(error: e.toString()));
      }
    });
    on<AddFavorite>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final response = await favoritesRepository.addFavorite(event.book);
        emit(FavoritesAdded());
      } catch (e) {
        emit(FavoritesError(error: e.toString()));
      }
    });
  }
}
