import 'package:bookstore/blocs/auth/auth_bloc.dart';
import 'package:bookstore/data/repositories/auth_repository.dart';
import 'package:bookstore/firebase_options.dart';
import 'package:bookstore/presentation/Home/home.dart';
import 'package:bookstore/presentation/Signin/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          title: 'Bookstore',
          theme: ThemeData(
            fontFamily: 'WorkSans',
            scaffoldBackgroundColor: const Color(0xFFE4F9F5),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
