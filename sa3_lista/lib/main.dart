import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa3_lista/Utils/TarefasController.dart';
import 'package:sa3_lista/view/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TarefasController(), 
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SA2',
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
