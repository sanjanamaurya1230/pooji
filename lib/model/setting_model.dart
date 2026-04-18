class AppSettingModel {
  AppSettingModel({
    required this.message,
    required this.data,
    required this.customerSupport,
  });

  final String? message;
  final List<AppData> data;
  final List<CustomerSupport> customerSupport;

  factory AppSettingModel.fromJson(Map<String, dynamic> json){
    return AppSettingModel(
      message: json["message"],
      data: json["data"] == null ? [] : List<AppData>.from(json["data"]!.map((x) => AppData.fromJson(x))),
      customerSupport: json["customer_support"] == null ? [] : List<CustomerSupport>.from(json["customer_support"]!.map((x) => CustomerSupport.fromJson(x))),
    );
  }

}

class CustomerSupport {
  CustomerSupport({
    required this.id,
    required this.type,
    required this.value,
    required this.createdAt,
  });

  final int? id;
  final String? type;
  final String? value;
  final DateTime? createdAt;

  factory CustomerSupport.fromJson(Map<String, dynamic> json){
    return CustomerSupport(
      id: json["id"],
      type: json["type"],
      value: json["value"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
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
