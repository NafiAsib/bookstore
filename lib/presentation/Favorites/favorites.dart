import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookstore/blocs/favorites/favorites_bloc.dart';

import 'package:bookstore/presentation/shared/widgets/book_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            // print(state);
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesLoaded) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: state.books.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return BookCard(
                    book: state.books[index],
                  );
                },
              );
            } else {
              context.read<FavoritesBloc>().add(const LoadFavorites());
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
