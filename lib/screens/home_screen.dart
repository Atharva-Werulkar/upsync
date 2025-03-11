import 'package:flutter/material.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/screens/add_app_screen.dart';
import 'package:upsync/screens/update_app_screen.dart';
import 'package:upsync/services/backend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<AppModel> apps = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UpSync - Manage App Versions')),
      body: FutureBuilder<List<AppModel>>(
        future: Backend.fetchApps(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No apps available'));
              } else {
                final apps = snapshot.data!;
                return ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return ListTile(
                      title: Text(app.appName),
                      subtitle: Text(
                        'Latest Version: ${app.latestVersion}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.update),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAppScreen(app: app),
                              ),
                            ),
                      ),
                    );
                  },
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddAppScreen()),
            ),
      ),
    );
  }
}
