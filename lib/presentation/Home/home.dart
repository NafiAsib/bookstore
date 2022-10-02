// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'package:bookstore/blocs/auth/auth_bloc.dart';
import 'package:bookstore/blocs/books/books_bloc.dart';

import 'package:bookstore/presentation/shared/widgets/book_card.dart';
import 'package:bookstore/presentation/Signin/signin.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookstore'),
        actions: [
          InkWell(
              onTap: () {
                _signOut(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text('Logout'),
                    SizedBox(width: 3),
                    Icon(Icons.logout_rounded),
                  ],
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0D7377),
        heroTag: 'favorites',
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => const Search()),
          // );
          // print('search tapped');
        },
        child: const Icon(
          Icons.favorite,
        ),
      ),
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
