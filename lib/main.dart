import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/notes_bloc.dart';
import 'pages/splash_page.dart';
import 'repository/app_database.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => NotesBloc(db: AppDatabase.db),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Bloc',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Itim',
      ),
      home: const SplashPage(),
    );
  }
}
