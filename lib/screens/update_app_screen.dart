import 'package:flutter/material.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/services/backend.dart';

class UpdateAppScreen extends StatefulWidget {
  final AppModel app;
  const UpdateAppScreen({super.key, required this.app});

  @override
  UpdateAppScreenState createState() => UpdateAppScreenState();
}

class UpdateAppScreenState extends State<UpdateAppScreen> {
  final TextEditingController versionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String updateType = 'minor_update';
  bool mandatoryUpdate = false;

  @override
  void initState() {
    super.initState();
    versionController.text = widget.app.latestVersion;
    notesController.text = widget.app.updateNotes;
    updateType = widget.app.update;
    mandatoryUpdate = widget.app.mandatoryUpdate;
  }

  Future<void> updateAppVersion() async {
    await Backend.updateAppVersion(
      AppModel(
        appId: widget.app.appId,
        appName: widget.app.appName,
        latestVersion: versionController.text,
        update: updateType,
        updateNotes: notesController.text,
        mandatoryUpdate: mandatoryUpdate,
        updatedAt: DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update App Version')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: versionController,
              decoration: const InputDecoration(labelText: 'New Version'),
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Update Notes'),
            ),
            SwitchListTile(
              title: const Text('Mandatory Update'),
              value: mandatoryUpdate,
              onChanged: (value) => setState(() => mandatoryUpdate = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateAppVersion,
              child: const Text('Update Version'),
            ),
          ],
        ),
      ),
    );
  }
}
