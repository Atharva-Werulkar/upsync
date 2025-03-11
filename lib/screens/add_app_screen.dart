import 'package:flutter/material.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/services/backend.dart';

class AddAppScreen extends StatefulWidget {
  const AddAppScreen({super.key});

  @override
  AddAppScreenState createState() => AddAppScreenState();
}

class AddAppScreenState extends State<AddAppScreen> {
  final TextEditingController appIdController = TextEditingController();
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  String updateType = 'minor_update';

  Future<void> addApp() async {
    await Backend.addApp(
      AppModel(
        appId: appIdController.text,
        appName: appNameController.text,
        latestVersion: versionController.text,
        update: updateType,
        updateNotes: 'initial version',
        mandatoryUpdate: false,
        updatedAt: DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: appIdController,
              decoration: const InputDecoration(labelText: 'App ID'),
            ),
            TextField(
              controller: appNameController,
              decoration: const InputDecoration(labelText: 'App Name'),
            ),
            TextField(
              controller: versionController,
              decoration: const InputDecoration(labelText: 'Latest Version'),
            ),
            DropdownButtonFormField(
              value: updateType,
              items:
                  ['minor_update', 'major_update', 'mandatory_update']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged:
                  (value) => setState(() => updateType = value as String),
              decoration: const InputDecoration(labelText: 'Update Type'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addApp, child: const Text('Add App')),
          ],
        ),
      ),
    );
  }
}
