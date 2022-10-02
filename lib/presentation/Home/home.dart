// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookstore/blocs/auth/auth_bloc.dart';
import 'package:bookstore/blocs/books/books_bloc.dart';
import 'package:bookstore/models/book.dart';
import 'package:bookstore/presentation/Signin/signin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookstore'),
        actions: [
          GestureDetector(
              onTap: () {
                _signOut(context);
              },
              child: const Text('Logout'))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   // splashColor: Color(0xFF0D7377),
      //   backgroundColor: Color(0xFF0D7377),
      //   // splashColor: Color(0xFF0D7377),
      //   heroTag: 'search',
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(builder: (context) => const Search()),
      //     );
      //     // print('search tapped');
      //   },
      //   child: const Icon(
      //     Icons.search,
      //   ),
      // ),
      body: KeyboardDismisser(
        gestures: const [
          GestureType.onVerticalDragDown,
          GestureType.onTap,
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Signin()),
                (route) => false,
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              suffix: GestureDetector(
                                onTap: () {
                                  if (searchController.text.isNotEmpty) {
                                    searchController.clear();
                                    context
                                        .read<BooksBloc>()
                                        .add(const LoadBooks());
                                  }
                                },
                                child: const Icon(Icons.clear),
                              ),

                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xFFBDD2B6)),
                                  borderRadius: BorderRadius.circular(15)
                                  // gapPadding: 20.0,
                                  ),

                              // label: Text('ex: flutter'),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              context.read<BooksBloc>().add(SearchBooks(
                                  searchQuery: searchController.text));
                            }
                            // BlocProvider.of<BooksBloc>(context).add(
                            //   SearchBooks(
                            //       searchQuery: searchController.text),
                            // );
                          },
                          child: Text('Search'))
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<BooksBloc, BooksState>(
                    builder: (context, state) {
                      if (state is BooksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BooksLoaded) {
                        // print(state.books);
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
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
                        // print(state);
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signOut(context) {
    BlocProvider.of<AuthBloc>(context).add(
      SignOut(),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;
    final title = book.volumeInfo?.title ?? "No title";
    final authors = book.volumeInfo?.authors ?? [];
    final publisher = book.volumeInfo?.publisher ?? "No publisher!";
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return BoolCardBottomSheet(book: book);
          }),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFBAD7DF),
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
    );
  }
}

class BoolCardBottomSheet extends StatelessWidget {
  const BoolCardBottomSheet({
    Key? key,
    required this.book,
  }) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;
    final title = book.volumeInfo?.title ?? "No title";
    final authors = book.volumeInfo?.authors ?? [];
    final publisher = book.volumeInfo?.publisher ?? "No publisher!";

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
