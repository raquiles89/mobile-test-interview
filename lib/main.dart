import 'package:dat_interview_test/model/user.dart';
import 'package:dat_interview_test/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider()..loadFromPrefs(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Manager',
      home: const UserPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed:
                () => {
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).fetchUsers(),
                },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => provider.deleteUser(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                ElevatedButton(
                  child: const Text("Add User"),
                  onPressed: () {
                    final newUser = User(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: nameCtrl.text,
                      email: emailCtrl.text,
                    );
                    provider.addUser(newUser);
                    nameCtrl.clear();
                    emailCtrl.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
