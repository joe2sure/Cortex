import 'package:get/get.dart';
import 'package:Cortex/screens/ai_writer/model/template_res_model.dart';

import '../../../utils/constants.dart';
import '../../subscription_plan/models/subscription_history_response.dart';
import '../../subscription_plan/models/subscription_plan_model.dart';

class HomeDetailRes {
  bool status;
  HomeData data;
  String message;

  HomeDetailRes({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory HomeDetailRes.fromJson(Map<String, dynamic> json) {
    return HomeDetailRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? HomeData.fromJson(json['data']) : HomeData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class HomeData {
  List<SystemService> systemService;
  List<SubscriptionModel> subscriptionPlan;
  List<CustomTemplate> customTemplate;
  List<RecentHistory> recentHistory;
  SubscriptionHistoryData? currentSubscription;

  HomeData({
    this.systemService = const <SystemService>[],
    this.subscriptionPlan = const <SubscriptionModel>[],
    this.customTemplate = const <CustomTemplate>[],
    this.recentHistory = const <RecentHistory>[],
    this.currentSubscription,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    List<RecentHistory> rH = json['recent_history'] is List ? List<RecentHistory>.from(json['recent_history'].map((x) => RecentHistory.fromJson(x))) : [];
    rH.removeWhere((element) => element.systemService.id.isNegative);
    return HomeData(
      systemService: json['system_service'] is List ? List<SystemService>.from(json['system_service'].map((x) => SystemService.fromJson(x))) : [],
      subscriptionPlan: json['subscription_plan'] is List ? List<SubscriptionModel>.from(json['subscription_plan'].map((x) => SubscriptionModel.fromJson(x))) : [],
      customTemplate: json['custom_template'] is List ? List<CustomTemplate>.from(json['custom_template'].map((x) => CustomTemplate.fromJson(x))) : [],
      recentHistory: rH,
      currentSubscription: json['current_subscription'] is Map ? SubscriptionHistoryData.fromJson(json['current_subscription']) : SubscriptionHistoryData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'system_service': systemService.map((e) => e.toJson()).toList(),
      'subscription_plan': subscriptionPlan.map((e) => e.toJson()).toList(),
      'custom_template': customTemplate.map((e) => e.toJson()).toList(),
      'recent_history': recentHistory.map((e) => e.toJson()).toList(),
      'current_subscription': currentSubscription?.toJson(),
    };
  }
}

class SystemService {
  int id;
  String type;
  String name;
  String description;
  int status;
  String serviceImage;

  SystemService({
    this.id = -1,
    this.type = "",
    this.name = "",
    this.description = "",
    this.status = -1,
    this.serviceImage = "",
  });

  factory SystemService.fromJson(Map<String, dynamic> json) {
    return SystemService(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int ? json['status'] : -1,
      serviceImage: json['service_image'] is String ? json['service_image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'status': status,
      'service_image': serviceImage,
    };
  }
}

class CategoryElement {
  int id;
  String type;
  String name;
  int parentId;
  String systemService;
  int status;
  String categoryImage;
  List<CustomTemplate> customTemplate;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  CategoryElement({
    this.id = -1,
    this.type = "",
    this.name = "",
    this.parentId = -1,
    this.systemService = "",
    this.status = -1,
    this.categoryImage = "",
    this.customTemplate = const <CustomTemplate>[],
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) {
    return CategoryElement(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      name: json['name'] is String ? json['name'] : "",
      parentId: json['parent_id'] is int ? json['parent_id'] : -1,
      systemService: json['system_service'] is String ? json['system_service'] : "",
      status: json['status'] is int ? json['status'] : -1,
      categoryImage: json['category_image'] is String ? json['category_image'] : "",
      customTemplate: json['custom_template'] is List ? List<CustomTemplate>.from(json['custom_template'].map((x) => CustomTemplate.fromJson(x))) : [],
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'parent_id': parentId,
      'system_service': systemService,
      'status': status,
      'category_image': categoryImage,
      'custom_template': customTemplate.map((e) => e.toJson()).toList(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class CustomTemplate {
  int id;
  String templateName;
  String description;
  int categoryId;
  String categorySlug;
  int packageId;
  int status;
  String templateImage;
  int inculdeVoiceTone;
  List<DynamicInputModel> userinputList;
  String customPrompt;
  String createdAt;
  String updatedAt;
  String deletedAt;
  bool isFreeTemplate;

  RxBool inWishList;

  CustomTemplate({
    this.id = -1,
    this.templateName = "",
    this.description = "",
    this.categoryId = -1,
    this.categorySlug = "",
    this.packageId = -1,
    this.status = -1,
    this.templateImage = "",
    this.inculdeVoiceTone = -1,
    this.userinputList = const <DynamicInputModel>[],
    this.customPrompt = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.isFreeTemplate = false,
    required this.inWishList,
  });

  factory CustomTemplate.fromJson(Map<String, dynamic> json) {
    return CustomTemplate(
      id: json['id'] is int ? json['id'] : -1,
      templateName: json['template_name'] is String ? json['template_name'] : "",
      description: json['description'] is String ? json['description'] : "",
      categoryId: json['category_id'] is int ? json['category_id'] : -1,
      categorySlug: json['category_slug'] is int ? json['category_slug'] : "",
      packageId: json['package_id'] is int ? json['package_id'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      templateImage: json['template_image'] is String ? json['template_image'] : "",
      inculdeVoiceTone: json['inculde_voice_tone'] is int ? json['inculde_voice_tone'] : -1,
      userinputList: json['userinput_list'] is List ? List<DynamicInputModel>.from(json['userinput_list'].map((x) => DynamicInputModel.fromJson(x))) : [],
      customPrompt: json['custom_prompt'] is String ? json['custom_prompt'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['updated_at'] : "",
      isFreeTemplate: json['identifier'] == FREE,
      inWishList: json['is_wishlist'] is int ? (json['is_wishlist'] == 1).obs : false.obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template_name': templateName,
      'description': description,
      'category_id': categoryId,
      'category_slug': categorySlug,
      'package_id': packageId,
      'status': status,
      'template_image': templateImage,
      'inculde_voice_tone': inculdeVoiceTone,
      'userinput_list': userinputList.map((e) => e.toJson()).toList(),
      'custom_prompt': customPrompt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'identifier': isFreeTemplate,
      'is_wishlist': inWishList.value,
    };
  }
}

class RecentHistory {
  int id;
  int userId;
  String type;
  String historyData;
  int wordCount;
  int imageCount;
  dynamic templateId;
  List<String> histroyImage;
  SystemService systemService;
  String createdAt;

  RecentHistory({
    this.id = -1,
    this.userId = -1,
    this.type = "",
    this.historyData = "",
    this.wordCount = -1,
    this.imageCount = -1,
    this.templateId,
    this.histroyImage = const <String>[],
    required this.systemService,
    this.createdAt = "",
  });

  factory RecentHistory.fromJson(Map<String, dynamic> json) {
    return RecentHistory(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      historyData: json['history_data'] is String ? json['history_data'] : "",
      wordCount: json['word_count'] is int ? json['word_count'] : -1,
      imageCount: json['image_count'] is int ? json['image_count'] : -1,
      templateId: json['template_id'],
      histroyImage: json['histroy_image'] is List ? List.from(json['histroy_image'].map((x) => x)) : const <String>[],
      systemService: json['system_service'] is Map ? SystemService.fromJson(json['system_service']) : SystemService(),
      createdAt: json['created_at'] is String ? json['created_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'history_data': historyData,
      'word_count': wordCount,
      'image_count': imageCount,
      'template_id': templateId,
      'histroy_image': histroyImage,
      'system_service': systemService.toJson(),
      'created_at': createdAt,
    };
  }
}
