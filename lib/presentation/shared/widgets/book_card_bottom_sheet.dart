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

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                BlocProvider.of<FavoritesBloc>(context)
                    .add(AddFavorite(book: book));
                Fluttertoast.showToast(
                    msg: 'Added to favorites!', fontSize: 20);
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
    );
  }
}
