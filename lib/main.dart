import 'package:bookstore/blocs/books/books_bloc.dart';
import 'package:bookstore/blocs/favorites/favorites_bloc.dart';
import 'package:bookstore/data/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bookstore/firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/blocs/auth/auth_bloc.dart';

import 'package:bookstore/data/repositories/auth_repository.dart';
import 'package:bookstore/data/repositories/books_repository.dart';

import 'package:bookstore/presentation/Home/home.dart';
import 'package:bookstore/presentation/Signin/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            authRepository: AuthRepository(),
          ),
        ),
        BlocProvider<BooksBloc>(
          create: (BuildContext context) => BooksBloc(
            bookRepository: BooksRepository(),
          )..add(const LoadBooks()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (BuildContext context) => FavoritesBloc(
            favoritesRepository: FavoritesRepository(),
          ),
        ),
        // RepositoryProvider<AuthRepository>(
        //     create: (context) => AuthRepository()),
        // RepositoryProvider<BooksRepository>(
        //     create: (context) => BooksRepository()),
        // RepositoryProvider<FavoritesRepository>(
        //     create: (context) => FavoritesRepository()),
      ],
      child: MaterialApp(
        title: 'Bookstore',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFA5DEE5),
              elevation: 2,
              centerTitle: false,
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          fontFamily: 'WorkSans',
          scaffoldBackgroundColor: const Color(0xFFE4F9F5),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              fontSize: 36,
            ),
            titleSmall: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const Home();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const Signin();
            }
          },
        ),
      ),
    );
  }
}
