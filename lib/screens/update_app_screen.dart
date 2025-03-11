import 'package:flutter/material.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/services/backend.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    versionController.text = widget.app.latestVersion;
    notesController.text = widget.app.updateNotes;
    updateType = widget.app.update;
    mandatoryUpdate = widget.app.mandatoryUpdate;
  }

  Future<void> updateAppVersion() async {
    setState(() {
      isLoading = true;
    });
    await Backend.updateAppVersion(
      AppModel(
        appId: widget.app.appId,
        appName: widget.app.appName,
        latestVersion: versionController.text,
        update: updateType,
        updateNotes: notesController.text,
        mandatoryUpdate: mandatoryUpdate,
        updatedAt: DateTime.now(),
        iconUrl: widget.app.iconUrl,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    versionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update App Version')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: ShadInput(
                        controller: versionController,
                        placeholder: const Text('New Version'),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: ShadInput(
                        controller: notesController,
                        placeholder: const Text('Update Notes'),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: ShadSwitch(
                        value: mandatoryUpdate,
                        onChanged:
                            (value) => setState(() => mandatoryUpdate = value),
                        label: const Text('Mandatory Update'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ShadButton(
                      onPressed: updateAppVersion,
                      child: const Text('Update Version'),
                    ),
                  ],
                ),
              ),
    );
  }
}
