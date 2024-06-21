class FileModel {
  final String path;
  final String name;

  FileModel({
    required this.path,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        // 'lastModified': lastModified.toIso8601String(),
      };

  static FileModel fromJson(Map<String, dynamic> json) => FileModel(
        path: json['path'],
        name: json['name'],
        //lastModified: DateTime.parse(json['lastModified']),
      );
}
