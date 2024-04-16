import 'package:flutter/material.dart';
import 'package:sa3_lista/Model/user.dart';
import 'package:sa3_lista/Utils/database_helper.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Register'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                final user = User(username: username, password: password);

                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O registro não pode conter informações vazias!'),
                    ),
                  );
                } else {
                  await DatabaseHelper().insertUser(user);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cadastro realizado com sucesso!'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Registrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
