import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookstore/models/book.dart';

import 'package:bookstore/presentation/shared/widgets/book_card_bottom_sheet.dart';

class BookCard extends StatelessWidget {
  const BookCard({
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
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return BookCardBottomSheet(book: book);
          }),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffe3fdfd), Color(0xffa5dee5)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                width: 10,
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
