class AppModel {
  final String appId;
  final String appName;
  final String latestVersion;
  final String updateNotes;
  final bool mandatoryUpdate;
  final String update;
  final DateTime updatedAt;

  AppModel({
    required this.appId,
    required this.appName,
    required this.latestVersion,
    required this.updateNotes,
    required this.mandatoryUpdate,
    required this.update,
    required this.updatedAt,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      appId: json['app_id'],
      appName: json['app_name'],
      latestVersion: json['latest_version'],
      updateNotes: json['update_notes'],
      mandatoryUpdate: json['mandatory_update'],
      update: json['update'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'app_name': appName,
      'latest_version': latestVersion,
      'update_notes': updateNotes,
      'mandatory_update': mandatoryUpdate,
      'update': update,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
