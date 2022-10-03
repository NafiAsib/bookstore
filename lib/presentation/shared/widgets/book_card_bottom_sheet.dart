import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookstore/models/book.dart';
import 'package:bookstore/blocs/favorites/favorites_bloc.dart';

class BookCardBottomSheet extends StatelessWidget {
  const BookCardBottomSheet({
    Key? key,
    required this.book,
  }) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;
    final title = book.volumeInfo?.title ?? "No title information";
    final authors = book.volumeInfo?.authors ?? [];
    final publisher = book.volumeInfo?.publisher ?? "No publisher information";

    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesAdded) {
          Fluttertoast.showToast(msg: state.msg, fontSize: 20);
        } else if (state is FavoritesError) {
          // print(state.error);
          Fluttertoast.showToast(msg: state.error, fontSize: 20);
        }
      },
      child: Container(
        color: const Color(0xFF737373),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff6f6f6), Color(0xffbbded6)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(AddFavorite(book: book));
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(0xFFE84545),
                  ),
                ),
              ),
              thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: thumbnail,
                      height: 160,
                      width: 128,
                      placeholder: (context, url) => SvgPicture.asset(
                        'assets/book-placeholder.svg',
                        width: 128,
                        height: 160,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/book-placeholder.svg',
                      width: 128,
                      height: 160,
                    ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ...authors.map<Widget>((author) => Text(author)),
                    const SizedBox(height: 5),
                    Text('Publisher: $publisher'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
