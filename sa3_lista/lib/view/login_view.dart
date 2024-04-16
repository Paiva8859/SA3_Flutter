import 'package:flutter/material.dart';
import 'package:sa3_lista/model/user.dart';
import 'package:sa3_lista/view/home_view.dart';
import 'package:sa3_lista/view/register_view.dart';
import 'package:sa3_lista/utils/database_helper.dart' as dbHelper;

class LoginView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                final user = await dbHelper.DatabaseHelper().getUser(username, password);
                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O login não pode conter informações vazias!'),
                    ),
                  );
                } else {
                  if (user != null && user.password == password) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(username: username),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Credenciais incorretas. Tente novamente.'),
                      ),
                    );
                  }
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RegisterView();
                  },
                );
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
