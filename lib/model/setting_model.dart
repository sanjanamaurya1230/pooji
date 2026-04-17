class AppSettingModel {
  final String message;
  final List<AppData> data;

  AppSettingModel({
    required this.message,
    required this.data,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<AppData>.from(
        json["data"].map((x) => AppData.fromJson(x)),
      ),
    );
  }
}

class AppData {
  AppData({
    required this.id,
    required this.type,
    required this.content,
  });

  final int? id;
  final String? type;
  final String? content;

  factory AppData.fromJson(Map<String, dynamic> json){
    return AppData(
      id: json["id"],
      type: json["type"],
      content: json["content"],
    );
  }

}
