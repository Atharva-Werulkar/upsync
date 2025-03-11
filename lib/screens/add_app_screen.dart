import 'package:flutter/material.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/services/backend.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:upsync/utils/consts.dart';

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

  bool isLoading = false;

  Future<void> addApp() async {
    setState(() {
      isLoading = true;
    });
    await Backend.addApp(
      AppModel(
        appId: appIdController.text,
        appName: appNameController.text,
        latestVersion: versionController.text,
        update: updateType,
        updateNotes: 'initial version',
        mandatoryUpdate: false,
        updatedAt: DateTime.now(),
        iconUrl: 'https://picsum.photos/200',
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    appIdController.dispose();
    appNameController.dispose();
    versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Add App', style: TextStyles.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      appIdController,
                      'App ID',
                      Icons.app_registration,
                    ),
                    _buildTextField(appNameController, 'App Name', Icons.apps),
                    _buildTextField(
                      versionController,
                      'Latest Version',
                      Icons.numbers,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ShadSelect<String>(
                        placeholder: const Text('Select Update Type'),

                        options: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 6, 6, 6),
                            child: Text(
                              'Update Types',
                              style: ShadTheme.of(
                                context,
                              ).textTheme.muted.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    ShadTheme.of(
                                      context,
                                    ).colorScheme.popoverForeground,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          ...[
                            'minor_update',
                            'major_update',
                            'mandatory_update',
                          ].map(
                            (e) => SizedBox(
                              height: 40,
                              child: ShadOption(
                                value: e,
                                child: Text(
                                  e.replaceAll('_', ' ').toUpperCase(),
                                  style: TextStyles.bodytext,
                                ),
                              ),
                            ),
                          ),
                        ],
                        selectedOptionBuilder:
                            (context, value) => Text(
                              value.replaceAll('_', ' ').toUpperCase(),
                              style: TextStyles.bodytext,
                            ),

                        onChanged:
                            (value) => setState(() => updateType = value!),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ShadButton(
                        onPressed: addApp,
                        child: const Text('Add App'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 60,
        child: ShadInput(
          controller: controller,
          placeholder: Text(label, style: TextStyles.bodytext),
          leading: Icon(icon),
        ),
      ),
    );
  }
}
