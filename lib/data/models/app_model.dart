import '../../domain/entities/app_entity.dart';

class AppModel extends AppEntity {
  AppModel({
    required super.id,
    required super.name,
    required super.platform,
    required super.version,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'],
      name: json['name'],
      platform: json['platform'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'version': version,
    };
  }
}
