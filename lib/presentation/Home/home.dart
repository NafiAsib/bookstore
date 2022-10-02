// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookstore/blocs/auth/auth_bloc.dart';
import 'package:bookstore/blocs/books/books_bloc.dart';
import 'package:bookstore/data/repositories/books_repository.dart';
import 'package:bookstore/models/book.dart';
import 'package:bookstore/presentation/Signin/signin.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // final bloc_ref = BlocProvider.of<AuthBloc>(context).stream.listen(
    //       (event) {

    //       },
    //     );
    return BlocProvider(
      create: (context) => BooksBloc(
        bookRepository: RepositoryProvider.of<BooksRepository>(context),
      )..add(LoadBooks()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookstore'),
          actions: [
            GestureDetector(
                onTap: () {
                  _signOut(context);
                },
                child: Text('Logout'))
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              // Navigate to the sign in screen when the user Signs Out
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Signin()),
                (route) => false,
              );
            }
          },
          child: BlocBuilder<BooksBloc, BooksState>(
            builder: (context, state) {
              if (state is BooksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BooksLoaded) {
                // print(state.books);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    itemCount: state.books.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return BookCard(
                        book: state.books[index],
                      );
                      // return Row(
                      //   children: [
                      //     state.books[index].imageLinks?.thumbnail != null
                      //         ? Image.network(
                      //             state.books[index].imageLinks!.thumbnail!)
                      //         : Text('no image')
                      //   ],
                      // );
                    },
                  ),
                );
              } else {
                // print(state);
                return Container();
              }
            },
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
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            book.imageLinks?.thumbnail != null
                ? Image.network(book.imageLinks!.thumbnail!)
                : Text('no image'),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  if (book.authors != null)
                    ...book.authors!.map<Widget>((author) => Text(author)),

                  const SizedBox(height: 5),
                  if (book.publisher != null)
                    Text('Publisher: ${book.publisher!}'),

                  // state.books[index].authors != null
                  //     ? state.books[index].authors?.map((author) => Text(author))
                  //     : Container(),
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          book.imageLinks?.thumbnail != null
              ? Image.network(book.imageLinks!.thumbnail!)
              : Text('no image'),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                if (book.authors != null)
                  ...book.authors!.map<Widget>((author) => Text(author)),

                const SizedBox(height: 5),
                if (book.publisher != null)
                  Text('Publisher: ${book.publisher!}'),

                // state.books[index].authors != null
                //     ? state.books[index].authors?.map((author) => Text(author))
                //     : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
